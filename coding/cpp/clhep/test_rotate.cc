/*
 * compile:
 * $ g++ test_rotate.cc `clhep-config --include --libs`
 *
 */
#include <CLHEP/Vector/ThreeVector.h>
#include <CLHEP/Vector/Rotation.h>

#include <iostream>

void test1() {
    CLHEP::Hep3Vector tv (0, 0, 1);
    CLHEP::Hep3Vector newUz (1, 0, 0);
    std::cout << tv << std::endl;
    tv.rotateUz(newUz);
    std::cout << tv << std::endl;
}

void test2() {
    CLHEP::Hep3Vector tv (0, 1, 0);
    CLHEP::Hep3Vector newUz (1, 0, 0);
    std::cout << tv << std::endl;
    tv.rotateUz(newUz);
    std::cout << tv << std::endl;
}

void test3() {
    CLHEP::Hep3Vector tv (0, 1, 0);
    CLHEP::Hep3Vector newUz (0, -1, 0);
    std::cout << tv << std::endl;
    tv.rotateUz(newUz);
    std::cout << tv << std::endl;
}

int main() {

    test1();
    test2();
    test3();
}
