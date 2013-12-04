#include <iostream>
#include "boost/signals.hpp"

struct Hello
{
    void operator()() const 
    {
        std::cout << "Hello!" << std::endl;
    }
};

struct World
{
    void operator()() const 
    {
        std::cout << "World!" << std::endl;
    }
};

void f() {
    std::cout << "f()" <<std::endl;
}

int main() {
    boost::signal<void ()> sig;

    Hello hello;
    World world;
    sig.connect(hello);
    sig.connect(world);
    sig.connect(f);

    sig();
}
