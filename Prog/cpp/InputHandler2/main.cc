
#include "InputHandler.h"
#include "TestStream/NormalTest1Stream.h"

#include <iostream>

int main() {
    InputHandler hinput;

    hinput.attachStream("K40", new NormalTest1Stream);

    hinput.attach("K40", "K40.root");

    std::cout << "FINALIZE" << std::endl;
    return 0;
}
