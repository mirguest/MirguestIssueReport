#include <boost/spirit/include/qi.hpp>         // Parsing
#include <boost/spirit/include/karma.hpp>      // Generation
#include <boost/fusion/adapted/std_pair.hpp>   // Make std::pair a fusion vector
#include <vector>

int main( int argc, char**argv)
{
    using namespace boost::spirit;
    //std::string str = "keyA=value1; keyB=value2;keyC=value3;";
    std::string str = "'keyA':1, 'keyB':2, \"keyC\":3";

    std::map<std::string,std::string> contents;
    std::string::iterator first = str.begin();
    std::string::iterator last  = str.end();

    const bool result = qi::phrase_parse(first,last, 
            *(
                *((qi::lit('\'') | qi::lit('"'))) >>
                *(qi::char_-":"-"'"-"\"") >>
                *((qi::lit('\'') | qi::lit('"'))) >>
                qi::lit(":") >> 
                *((qi::lit('\'') | qi::lit('"'))) >>
                *(qi::char_-","-"'"-"\"") >>
                *((qi::lit('\'') | qi::lit('"'))) >>
                -(qi::lit(",")) ),
            ascii::space, contents);                                  

    assert(result && first==last);

    std::cout << karma::format(*(karma::string << '=' <<
                karma::string << karma::eol), contents);


    std::string str2 = "1, 2, 3";
    std::string::iterator first2 = str2.begin();
    std::string::iterator last2  = str2.end();
    std::vector<std::string> vi;

    const bool result2 = qi::phrase_parse(first2, last2,
            *(
                *(qi::char_-",") >>
                -(qi::lit(","))
                ),
            ascii::space, vi);
    assert(result && first==last);



}
