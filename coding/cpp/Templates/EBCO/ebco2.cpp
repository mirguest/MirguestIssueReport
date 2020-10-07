#include <iostream>

class Empty {
    typedef int Int;
};

class EmptyToo: public Empty {

};

class NonEmpty: public Empty, public EmptyToo {

};

int main() {
    std::cout << "sizeof(Empty) " << sizeof(Empty) << std::endl;
    std::cout << "sizeof(EmptyToo) " << sizeof(EmptyToo) << std::endl;
    std::cout << "sizeof(NonEmpty) " << sizeof(NonEmpty) << std::endl;
}
