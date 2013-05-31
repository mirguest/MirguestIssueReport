#include <iostream>
#include <typeinfo>

template <class C>
struct my_traits {
    typedef typename C::type value_type;
};

struct my_c {
    typedef my_c type;
};

template<>
struct my_traits<int> {
    typedef int value_type;
};

template<>
struct my_traits<float> {
    typedef float value_type;
};

template <class C>
void f() {
    typename my_traits<C>::value_type i;
    std::cout << typeid(C).name() 
              << " :"
              << sizeof(i)
              << std::endl;
};

template <class C>
struct my_traits<C*> {
    typedef C value_type;
};

template <class C>
struct my_traits<C**> {
    typedef C value_type;
};

int main() {

    f<my_c>();
    f<int>();
    f<float>();
    f<double*>();
    f<double**>();

}
