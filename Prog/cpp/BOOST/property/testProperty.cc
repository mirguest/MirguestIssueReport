#include <iostream>
#include <vector>
#include <map>
#include "Property.hh"
#include "HelperParse.hh"

void test_parseQuoted() {
    std::cout << "Begin Test Quoted String" << std::endl;
    std::string s_1("\"hello, world\"");
    std::string s_2("'hello, world'");

    std::string result_1;
    std::string result_2;

    Helper::parseQuoted(s_1, result_1);
    Helper::parseQuoted(s_2, result_2);

    std::cout << result_1 << std::endl;
    std::cout << result_2 << std::endl;
    std::cout << "End Test Quoted String" << std::endl;
}

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

    std::map< std::string, double > msd;
    PropertyBase* pb_msd = declareProperty("key_map_str_double", msd);
    setProperty(pb_msd, "'key1':1.2, 'key2':3.4");

    test_parseQuoted();

}
