#include <CL/sycl.hpp>
#include <iostream>
#include <vector>
#include <array>
using namespace sycl;

const std::string secret {
                          "Ifmmp-!xpsme\"\012J(n!tpssz-!Ebwf/!"
                          "J(n!bgsbje!J!dbo(u!ep!uibu/!.!IBM\01"};
const auto sz = secret.size();

int main() {
    queue Q;

    char*result = malloc_shared<char>(sz, Q);
    std::memcpy(result,secret.data(),sz);

    Q.parallel_for(sz,[=](auto&i) {
        result[i] -= 1;
        }).wait();

    std::cout << result << "\n";

    size_t n = 5;
    double alpha = 1.2;
    std::vector<double> x1{1,2,3,4,5};
    std::vector<double> y1{1,2,3,4,5};

    auto x = malloc_shared<double>(n, Q);
    auto y = malloc_shared<double>(n, Q);
    auto z = malloc_shared<double>(n, Q);

    std::memcpy(x, x1.data(), n*sizeof(double));
    std::memcpy(y, y1.data(), n*sizeof(double));

    Q.parallel_for(range{n}, [=](id<1> i){
        z[i] = alpha * x[i] + y[i];
    }).wait();

    for (int i = 0; i < n; ++i) {
        std::cout << x[i] << " " << y[i] << " " << z[i] << std::endl;
    }

    constexpr int size = 16;
    std::array<int, size> data;

    buffer B {data};

    Q.submit([&](handler& h) {
        accessor A{B, h};

        h.parallel_for(size, [=](auto& idx){
            A[idx] = idx;
        });
    });

    host_accessor A{B};
    for (int i = 0; i < size; ++i) {
        std::cout << "data[" << i << "] = " << A[i] << std::endl;
    }

    return 0;
}
