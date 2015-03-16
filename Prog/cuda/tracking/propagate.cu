////////////////////////////////////////////////////////////////////////////
//
// Copyright 1993-2014 NVIDIA Corporation.  All rights reserved.
//
// Please refer to the NVIDIA end user license agreement (EULA) associated
// with this source code for terms and conditions that govern your use of
// this software. Any use, reproduction, disclosure, or distribution of
// this software and related documentation outside the terms of the EULA
// is strictly prohibited.
//
////////////////////////////////////////////////////////////////////////////

/* Template project which demonstrates the basics on how to setup a project
* example application.
* Host code.
*/

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

// includes CUDA
#include <cuda_runtime.h>
#include <curand_kernel.h>
#include <math_constants.h>
// includes, project
#include <helper_cuda.h>
#include <helper_functions.h> // helper functions for SDK examples

////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest(int argc, char **argv);

extern "C"
void computeGold(float *reference, float *idata, const unsigned int len);

////////////////////////////////////////////////////////////////////////////////
//! Simple test kernel for device functionality
//! @param g_idata  input data in global memory
//! @param g_odata  output data in global memory
////////////////////////////////////////////////////////////////////////////////
__global__ void
testKernel(float *g_idata, float *g_odata)
{
    // shared memory
    // the size is determined by the host application
    extern  __shared__  float sdata[];

    // access thread id
    const unsigned int tid = threadIdx.x;
    // access number of threads in this block
    const unsigned int num_threads = blockDim.x;

    // read in input data from global memory
    sdata[tid] = g_idata[tid];
    __syncthreads();

    // perform some computations
    sdata[tid] = (float) num_threads * sdata[tid];
    __syncthreads();

    // write data to global memory
    g_odata[tid] = sdata[tid];
}

__global__ void
init_rand_state(curandState* state, unsigned int seed) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    curand_init(seed, id, 0, &state[id]);
}

__global__ void
generate_op_uniform(curandState *state,
                    float* op_px, float* op_py, float* op_pz) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    /* Copy state to local memory for efficiency */
    curandState localState = state[id];

    // == theta and phi ==
    float costheta = -1. + 2*curand_uniform(&localState);
    float sintheta = sqrtf(1-costheta*costheta);
    float phi = 2*CUDART_PI_F*curand_uniform(&localState);

    op_px[id] = 1.*sintheta*cosf(phi);
    op_py[id] = 1.*sintheta*sinf(phi);
    op_pz[id] = 1.*costheta;

    /* Copy state back to global memory */
    state[id] = localState;
}

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char **argv)
{
    runTest(argc, argv);
}

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void
runTest(int argc, char **argv)
{
    bool bTestResult = true;

    printf("%s Starting...\n\n", argv[0]);

    // use command-line specified CUDA device, otherwise use device with highest Gflops/s
    int devID = findCudaDevice(argc, (const char **)argv);

    StopWatchInterface *timer = 0;
    sdkCreateTimer(&timer);
    sdkStartTimer(&timer);

    unsigned int num_threads = 32;
    unsigned int num_blocks = 64;
    unsigned int mem_size = sizeof(float) * num_threads;

    // allocate host memory
    float *h_idata = (float *) malloc(mem_size);

    // initalize the memory
    for (unsigned int i = 0; i < num_threads; ++i)
    {
        h_idata[i] = (float) i;
    }

    // allocate device memory
    float *d_idata;
    checkCudaErrors(cudaMalloc((void **) &d_idata, mem_size));
    // copy host memory to device
    checkCudaErrors(cudaMemcpy(d_idata, h_idata, mem_size,
                               cudaMemcpyHostToDevice));

    // allocate device memory for result
    float *d_odata;
    checkCudaErrors(cudaMalloc((void **) &d_odata, mem_size));

    // setup execution parameters
    dim3  grid(num_blocks, 1, 1);
    dim3  threads(num_threads, 1, 1);

    // execute the kernel
    //testKernel<<< grid, threads, mem_size >>>(d_idata, d_odata);

    // random generator
    curandState *devStates = 0;
    cudaMalloc((void **)&devStates, grid.x * threads.x * 
                              sizeof(curandState));

    float *h_oppx = 0;
    float *h_oppy = 0;
    float *h_oppz = 0;
    h_oppx = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_oppy = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_oppz = (float*)malloc(grid.x * threads.x * sizeof(float));

    float *d_oppx = 0;
    float *d_oppy = 0;
    float *d_oppz = 0;

    cudaMalloc((void**)&d_oppx, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_oppy, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_oppz, grid.x * threads.x * sizeof(float));

    init_rand_state<<< grid, threads >>>(devStates, 42);

    generate_op_uniform<<< grid, threads >>>(devStates, d_oppx, d_oppy, d_oppz);

    // check if kernel execution generated and error
    getLastCudaError("Kernel execution failed");

    // == copy data back to host ==
    cudaMemcpy(h_oppx, d_oppx, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_oppy, d_oppy, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_oppz, d_oppz, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);


    // allocate mem for the result on host side
    float *h_odata = (float *) malloc(mem_size);
    // copy result from device to host
    checkCudaErrors(cudaMemcpy(h_odata, d_odata, sizeof(float) * num_threads,
                               cudaMemcpyDeviceToHost));

    sdkStopTimer(&timer);
    printf("Processing time: %f (ms)\n", sdkGetTimerValue(&timer));
    sdkDeleteTimer(&timer);


    // print the data
    for (int i = 0; i < grid.x*threads.x; ++i) {
        std::cout << h_oppx[i] << " " << h_oppy[i] << " " << h_oppz[i] << std::endl;
    }

    // compute reference solution
    // float *reference = (float *) malloc(mem_size);
    // computeGold(reference, h_idata, num_threads);

    // check result
    // if (checkCmdLineFlag(argc, (const char **) argv, "regression"))
    // {
    //     // write file for regression test
    //     sdkWriteFile("./data/regression.dat", h_odata, num_threads, 0.0f, false);
    // }
    // else
    // {
    //     // custom output handling when no regression test running
    //     // in this case check if the result is equivalent to the expected soluion
    //     bTestResult = compareData(reference, h_odata, num_threads, 0.0f, 0.0f);
    // }

    // cleanup memory
    free(h_idata);
    free(h_odata);
    // free(reference);
    checkCudaErrors(cudaFree(d_idata));
    checkCudaErrors(cudaFree(d_odata));

    // cudaDeviceReset causes the driver to clean up all state. While
    // not mandatory in normal operation, it is good practice.  It is also
    // needed to ensure correct operation when the application is being
    // profiled. Calling cudaDeviceReset causes all profile data to be
    // flushed before the application exits   
    cudaDeviceReset();
    exit(bTestResult ? EXIT_SUCCESS : EXIT_FAILURE);
}
