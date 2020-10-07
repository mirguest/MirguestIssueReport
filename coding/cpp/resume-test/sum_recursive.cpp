/*
 * =====================================================================================
 *
 *       Filename:  sum_recursive.cpp
 *
 *    Description:  Don't use any of for, while, if, switch and so on.
 *
 *        Version:  1.0
 *        Created:  2015年10月10日 22时07分00秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <iostream>

template<int i>
struct A {
    static const int val = i+A<i-1>::val;
};

// template specialization
template<>
struct A<1> {
    static const int val = 1;
};

int main() {
    std::cout << A<10>::val << std::endl;
    std::cout << A<100>::val << std::endl;
    std::cout << A<1000>::val << std::endl;
}
