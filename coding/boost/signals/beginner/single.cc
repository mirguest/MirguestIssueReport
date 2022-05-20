#include <iostream>
#include "boost/signals.hpp"

struct HelloWorld
{
    void operator()() const 
    {
        std::cout << "Hello, World!" << std::endl;
    }
};

int main() {
    boost::signal<void ()> sig;

    HelloWorld hello;
    sig.connect(hello);

    sig();
}
