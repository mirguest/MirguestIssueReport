#include <iostream>

class Empty {
    typedef int Int;
};

class EmptyToo: virtual public Empty {

};

class NonEmpty: virtual public Empty, virtual public EmptyToo {

};

int main() {
    std::cout << "sizeof(Empty) " << sizeof(Empty) << std::endl;
    std::cout << "sizeof(EmptyToo) " << sizeof(EmptyToo) << std::endl;
    std::cout << "sizeof(NonEmpty) " << sizeof(NonEmpty) << std::endl;
}
