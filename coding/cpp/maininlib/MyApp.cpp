#include "MyApp.h"
#include <iostream>
App* app = 0;
MyApp myapp;

MyApp::MyApp() {
    app = this;
}

int MyApp::run() {
    std::cout << "begin running..." << std::endl;

    std::cout << "stop..." << std::endl;
    return 0;
}
