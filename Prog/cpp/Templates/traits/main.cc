#include <iostream>
#include "isclasst.hpp"
typedef char RT1;
typedef struct{char a[2];} RT2;
template<typename T> RT1 test(typename T::X const*);
template<typename T> RT2 test(...);

class A {

};


int main() {
    std::cout << IsClassT<int>::Yes << std::endl;
    std::cout << IsClassT<A>::Yes << std::endl;

    test<A>;
    std::cout << sizeof test<A>() << std::endl;
}
