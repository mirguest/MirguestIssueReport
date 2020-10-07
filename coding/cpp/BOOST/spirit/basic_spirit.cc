#include <iostream>
#include <boost/spirit/include/qi.hpp>         // Parsing

void f(double x) {
    std::cout << "get " << x << std::endl;
}

using namespace boost::spirit;
int main() {
    int value = 0;
    std::string str("123");
    std::string::iterator strbegin = str.begin();

    qi::parse(strbegin, str.end(), int_, value);
    std::cout << value << std::endl;

    str = "(1.0, 2.0)";
    strbegin = str.begin();
    double p1,p2;
    qi::phrase_parse(strbegin, str.end(),
            '(' >> qi::double_ >> ", " >> qi::double_ >> ')',
            qi::space,
            p1, p2);
    std::cout << p1 << ", " << p2 << std::endl;

    str = "1.0";
    strbegin = str.begin();
    double d;
    qi::phrase_parse(strbegin, str.end(),
            qi::double_[f],
            qi::space);


    
}
