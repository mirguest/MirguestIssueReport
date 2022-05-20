/*
 * $ dpcpp -fsycl hello-vecmem.cpp  -I/home/tao/vecmem-install/include -std=c++17 -DVECMEM_HAVE_PMR_MEMORY_RESOURCE -L/home/tao/vecmem-install/lib -lvecmem_core -lvecmem_sycl
 */

#include <CL/sycl.hpp>


#include "vecmem/containers/array.hpp"
#include "vecmem/containers/const_device_array.hpp"
#include "vecmem/containers/const_device_vector.hpp"
#include "vecmem/containers/device_vector.hpp"
#include "vecmem/containers/static_array.hpp"
#include "vecmem/containers/vector.hpp"
#include "vecmem/memory/atomic.hpp"
#include "vecmem/memory/device_atomic_ref.hpp"
#include "vecmem/memory/sycl/device_memory_resource.hpp"
#include "vecmem/memory/sycl/host_memory_resource.hpp"
#include "vecmem/memory/sycl/shared_memory_resource.hpp"
#include "vecmem/utils/sycl/copy.hpp"


int main() {

    sycl::queue q;

    vecmem::sycl::shared_memory_resource shared_mr(&q);

    return 0;
}