#include "MyApp.h"
App* app = 0;
MyApp myapp;

MyApp::MyApp() {
    app = this;
}

int MyApp::run() {
    return 0;
}
