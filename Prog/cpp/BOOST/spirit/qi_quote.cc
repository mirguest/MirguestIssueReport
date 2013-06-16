#include <iostream>
#include <boost/spirit/include/qi.hpp>         // Parsing
#include <boost/spirit/include/phoenix.hpp>
#include <boost/fusion/adapted.hpp>

using namespace boost::spirit;

int main() {

    std::string str1("'hello, world'");
    std::string str2("\"hello, world\"");
    std::string str3("'hello,\" world'");
    std::string str4("'hello,\\\' world'");

    qi::rule<std::string::iterator, 
             std::string(), 
             ascii::space_type> quoted_string;
    char qq;
    quoted_string %= qi::lexeme[
                     (qi::lit("'")|qi::lit("\""))
                  >> +(ascii::char_ - qi::lit("'")|qi::lit("\""))
                  >> qi::lit("'")|qi::lit("\"")
                     ];
    quoted_string %= qi::lexeme[
                     (qi::lit("'")
                  >> +(qi::lit("\\\'")|(ascii::char_ - qi::lit("'")))
                  >> qi::lit("'"))
                     |
                     (qi::lit("\"")
                  >> +(qi::lit("\\\"")|(ascii::char_ - qi::lit("\"")))
                  >> qi::lit("\""))
                     ];

    std::string result;

    std::string::iterator strbegin;

    result.clear();
    strbegin = str1.begin();
    bool r = qi::phrase_parse(strbegin, str1.end(),
            quoted_string,
            ascii::space,
            result);
    std::cout << "str1: " << str1 << std::endl;
    std::cout << r << std::endl;
    std::cout << result << std::endl;

    result.clear();
    strbegin = str2.begin();
    r = qi::phrase_parse(strbegin, str2.end(),
            quoted_string,
            ascii::space,
            result);
    std::cout << "str2: " << str2 << std::endl;
    std::cout << r << std::endl;
    std::cout << result << std::endl;

    result.clear();
    strbegin = str3.begin();
    r = qi::phrase_parse(strbegin, str3.end(),
            quoted_string,
            ascii::space,
            result);
    std::cout << "str3: " << str3 << std::endl;
    std::cout << r << std::endl;
    std::cout << result << std::endl;

    result.clear();
    strbegin = str4.begin();
    r = qi::phrase_parse(strbegin, str4.end(),
            quoted_string,
            ascii::space,
            result);
    std::cout << "str4: " << str4 << std::endl;
    std::cout << r << std::endl;
    std::cout << result << std::endl;
}
