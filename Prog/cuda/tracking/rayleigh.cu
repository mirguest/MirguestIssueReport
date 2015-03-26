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

#define CONSTANT_LS_BALL_R 17500.
#define CONSTANT_LS_RINDEX 1.50
#define CONSTANT_WATER_RINDEX 1.33
#define CONSTANT_PMT_BALL_R 19500.
#define CONSTANT_MEAN_PATH_LS 60000.
#define CONSTANT_RAYLEIGH_LS 30000.
#define CONSTANT_MEAN_PATH_WATER 30000.

////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest(int argc, char **argv);

////////////////////////////////////////////////////////////////////////////////
__global__ void
init_rand_state(curandState* state, unsigned int seed) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    curand_init(seed, id, 0, &state[id]);
}

////////////////////////////////////////////////////////////////////////////////
__global__ void
generate_op_uniform(curandState *state,
                    float* op_px,   float* op_py,   float* op_pz,
                    float* op_polx, float* op_poly, float* op_polz) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    /* Copy state to local memory for efficiency */
    curandState localState = state[id];

    // == theta and phi ==
    float costheta = -1. + 2*curand_uniform(&localState);
    float sintheta = sqrtf(1-costheta*costheta);
    float phi = 2*CUDART_PI_F*curand_uniform(&localState);
    float cosphi = cosf(phi);
    float sinphi = sinf(phi);

    op_px[id] = 1.*sintheta*cosphi;
    op_py[id] = 1.*sintheta*sinphi;
    op_pz[id] = 1.*costheta;

    // == in a local coordinate, generate polarization in x-y plane ==
    float pol_phi = 2*CUDART_PI_F*curand_uniform(&localState);
    float dx = cosf(pol_phi);
    float dy = sinf(pol_phi);
    // === rotate the polarization ===
    op_polx[id] = cosphi*costheta*dx - sinphi*dy;
    op_poly[id] = sinphi*costheta*dx + cosphi*dy;
    op_polz[id] = -sintheta*dx;;

    /* Copy state back to global memory */
    state[id] = localState;
}

__device__ void
rotateUz(const float& u1, const float& u2, const float& u3, 
         float& dx, float& dy, float& dz) {
    // rotate (dx, dy, dz) to (dx', dy', dz')
    // copy from CLHEP::ThreeVector::rotateUz
    float up = u1*u1 + u2*u2;

    if (up>0) {
        up = sqrtf(up);
        double px = dx,  py = dy,  pz = dz;
        dx = (u1*u3*px - u2*py)/up + u1*pz;
        dy = (u2*u3*px + u1*py)/up + u2*pz;
        dz =    -up*px +             u3*pz;
    } else if (u3 < 0.) {
        dx = -dx;
        dz = -dz;
    }
}

__device__ void
do_rayleigh(curandState& state,
            float& op_px,   float& op_py,   float& op_pz,
            float& op_polx, float& op_poly, float& op_polz) {
    float sc_op_px, sc_op_py, sc_op_pz;
    float sc_op_polx, sc_op_poly, sc_op_polz;

    int cnt = 0;
    while(true) {
        // == sample the scattering momentum ==
        // === sample the scattering momentum in local coordiniate ===
        float costheta = -1. + 2*curand_uniform(&state);
        float sintheta = sqrtf(1-costheta*costheta);
        float phi = 2*CUDART_PI_F*curand_uniform(&state);
        float cosphi = cosf(phi);
        float sinphi = sinf(phi);

        sc_op_px = 1.*sintheta*cosphi;
        sc_op_py = 1.*sintheta*sinphi;
        sc_op_pz = 1.*costheta;
        // === rotate the scattering momentum in global coordiniate ===
        rotateUz(op_px, op_py, op_pz, sc_op_px, sc_op_py, sc_op_pz);

        // == caculate the scattering polarization ==
        // pol_sc = (pol - cos(alpha) n)/sin(alpha)
        // alpha is the angle between n and pol.
        float cosalpha = op_polx * sc_op_px
                       + op_poly * sc_op_py
                       + op_polz * sc_op_pz;
        float sinalpha = sqrtf(1.-cosalpha*cosalpha);
        sc_op_polx = (op_polx - cosalpha*sc_op_px)/sinalpha;
        sc_op_poly = (op_poly - cosalpha*sc_op_py)/sinalpha;
        sc_op_polz = (op_polz - cosalpha*sc_op_pz)/sinalpha;

        // == sample using cos(theta)**2 ==
        // === cos(theta_pol) = pol dot sc_pol ===
        float costhetap = op_polx*sc_op_polx
                        + op_poly*sc_op_poly
                        + op_polz*sc_op_polz;
        if (curand_uniform(&state) <= powf(costhetap,2)) {
            break;
        }
        // FIXME
        if (++cnt>100) {
            break;
        }
    }

    op_px = sc_op_px;
    op_py = sc_op_py;
    op_pz = sc_op_pz;

    op_polx = sc_op_polx;
    op_poly = sc_op_poly;
    op_polz = sc_op_polz;
}
////////////////////////////////////////////////////////////////////////////////
__global__ void
propagate_op_rayleigh(curandState *state,
                    float* op_px,   float* op_py,   float* op_pz,
                    float* op_polx, float* op_poly, float* op_polz) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    // Copy state to local memory for efficiency 
    curandState localState = state[id];

    do_rayleigh(localState, op_px[id],   op_py[id],   op_pz[id],
                            op_polx[id], op_poly[id], op_polz[id]);

    // Copy state back to global memory
    state[id] = localState;
}
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
    printf("%s Starting...\n\n", argv[0]);

    // use command-line specified CUDA device, otherwise use device with highest Gflops/s
    int devID = findCudaDevice(argc, (const char **)argv);

    StopWatchInterface *timer = 0;
    sdkCreateTimer(&timer);
    sdkStartTimer(&timer);

    // unsigned int num_threads = 1; //32;
    // unsigned int num_blocks = 1; //64;
    unsigned int num_threads = 32;
    unsigned int num_blocks = 64;

    unsigned int total_photon = num_threads * num_blocks;

    int init_pos_x = 0;
    int init_pos_y = 0;
    int init_pos_z = 0;

    // setup execution parameters
    dim3  grid(num_blocks, 1, 1);
    dim3  threads(num_threads, 1, 1);

    // == initialize random generator =
    curandState *devStates = 0;
    cudaMalloc((void **)&devStates, grid.x * threads.x * 
                              sizeof(curandState));

    // == position ==
    // set the initial position
    // default unit is mm, (same as geant4)
    float *h_op_x = 0;
    float *h_op_y = 0;
    float *h_op_z = 0;
    h_op_x = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_op_y = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_op_z = (float*)malloc(grid.x * threads.x * sizeof(float));

    for (int i = 0; i < grid.x * threads.x; ++i) {
        h_op_x[i] = init_pos_x; // 0m
        h_op_y[i] = init_pos_y; // 0m
        h_op_y[i] = init_pos_z; // 0m
    }

    float *d_op_x = 0;
    float *d_op_y = 0;
    float *d_op_z = 0;

    cudaMalloc((void**)&d_op_x, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_op_y, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_op_z, grid.x * threads.x * sizeof(float));

    cudaMemcpy(d_op_x, h_op_x, grid.x * threads.x * sizeof(float),
                        cudaMemcpyHostToDevice); 
    cudaMemcpy(d_op_y, h_op_y, grid.x * threads.x * sizeof(float),
                        cudaMemcpyHostToDevice); 
    cudaMemcpy(d_op_z, h_op_z, grid.x * threads.x * sizeof(float),
                        cudaMemcpyHostToDevice); 

    // = initialize =
    // == momentum ==
    float *h_op_px = 0;
    float *h_op_py = 0;
    float *h_op_pz = 0;
    h_op_px = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_op_py = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_op_pz = (float*)malloc(grid.x * threads.x * sizeof(float));

    float *d_op_px = 0;
    float *d_op_py = 0;
    float *d_op_pz = 0;

    cudaMalloc((void**)&d_op_px, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_op_py, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_op_pz, grid.x * threads.x * sizeof(float));

    // == polarization ==
    float *h_op_polx = 0;
    float *h_op_poly = 0;
    float *h_op_polz = 0;
    h_op_polx = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_op_poly = (float*)malloc(grid.x * threads.x * sizeof(float));
    h_op_polz = (float*)malloc(grid.x * threads.x * sizeof(float));

    float *d_op_polx = 0;
    float *d_op_poly = 0;
    float *d_op_polz = 0;

    cudaMalloc((void**)&d_op_polx, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_op_poly, grid.x * threads.x * sizeof(float));
    cudaMalloc((void**)&d_op_polz, grid.x * threads.x * sizeof(float));

    // = execute =
    // == initialize the random engine ==
    init_rand_state<<< grid, threads >>>(devStates, 42);
    // == generate optical photons ==
    // === generate the direction ===
    generate_op_uniform<<< grid, threads >>>(devStates, 
            d_op_px,   d_op_py,   d_op_pz,
            d_op_polx, d_op_poly, d_op_polz);

    propagate_op_rayleigh<<< grid, threads >>>(devStates, 
            d_op_px,   d_op_py,   d_op_pz,
            d_op_polx, d_op_poly, d_op_polz);

    // = finalize =
    // == copy data back to host ==
    // === copy data back to host (position)===
    cudaMemcpy(h_op_x, d_op_x, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_op_y, d_op_y, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_op_z, d_op_z, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    // === copy data back to host (momentum)===
    cudaMemcpy(h_op_px, d_op_px, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_op_py, d_op_py, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_op_pz, d_op_pz, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    // === copy data back to host (polarization)===
    cudaMemcpy(h_op_polx, d_op_polx, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_op_poly, d_op_poly, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);
    cudaMemcpy(h_op_polz, d_op_polz, grid.x * threads.x * sizeof(float),
                        cudaMemcpyDeviceToHost);

    // = display the results =
    for (int i = 0; i < grid.x*threads.x; ++i) {
        std::cout << h_op_x[i] << " " << h_op_y[i] << " " << h_op_z[i] << " "
                  << h_op_px[i] << " " << h_op_py[i] << " " << h_op_pz[i] << " "
                  << h_op_polx[i] << " " << h_op_poly[i] << " " << h_op_polz[i] << " "
                  << std::endl;
    }

}
