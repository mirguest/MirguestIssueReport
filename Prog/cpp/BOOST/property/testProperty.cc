#include <iostream>
#include <vector>
#include "Property.hh"

int main () {
    int i = 0;
    float f = 0.0;

    PropertyBase* pb_int = declareProperty<int>("key_int", i);
    PropertyBase* pb_float = declareProperty<float>("key_float", f);

    setProperty(pb_int, "1");
    setProperty(pb_float, "2.0");

    std::cout << i << std::endl;
    std::cout << f << std::endl;

    std::vector<int> vi;
    PropertyBase* pb_vi = declareProperty("key_vector_int", vi);
    std::cout << pb_vi << std::endl;
    setProperty(pb_vi, "1,2,3");
}
