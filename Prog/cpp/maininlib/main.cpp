#include <iostream>

class App;
extern App* app;

int main() {
    if (!app) {
        std::cout << "can't load app" << std::endl;
    } else {
        std::cout << "load app" << std::endl;
    }
}
