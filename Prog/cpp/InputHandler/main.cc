#include <iostream>
#include <list>

#include "SingleInputHandler.h"

void test_single_input() {
    SingleInputHandler SIH;
    std::list<std::string> lists;
    lists.push_back("hello.txt");
    lists.push_back("world.txt");
    SIH.inputs(lists);

    SIH.Buffer(std::cout);
    std::cout << std::endl;
}

int main () {
    test_single_input();

}
