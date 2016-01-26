#include "MyApp2.h"
#include <iostream>
App* app = 0;
MyApp2 myapp;

MyApp2::MyApp2() {
    app = this;
}

int MyApp2::run() {
    std::cout << "begin running..." << std::endl;

    std::cout << "stop..." << std::endl;
    return 0;
}
