#include "HelperParse.hh"
#include <algorithm>
#include <boost/spirit/include/qi.hpp>         // Parsing
#include <boost/spirit/include/phoenix.hpp>
#include <boost/fusion/adapted.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/bind.hpp>

namespace Helper {

namespace qi = boost::spirit::qi;
namespace ascii = boost::spirit::ascii;
using namespace boost::algorithm;

struct esc_parser:qi::symbols<char,char>
{
    esc_parser()
    {
        add("\\t",'\t')
            ("\\n",'\n')
            ("\\\"",'"')
            ("\\'",'\'')
            // etc.
            ;
     }
}; 

bool parseQuoted(const std::string& input, std::string& output) {
    qi::rule<std::string::const_iterator, 
             std::string(), 
             ascii::space_type> quoted_string;
    esc_parser escaped;
    quoted_string %= *qi::space 
                  >> qi::lexeme[
                  // single quote
                     
                     (qi::lit("'")
                  >> +(
                        escaped
                        |
                        (ascii::char_ - qi::lit("'")))
                  >> qi::lit("'"))
                     |
                  // double quote
                     (qi::lit("\"")
                  >> +(
                        escaped
                        |
                        (ascii::char_ - qi::lit("\"")))
                  >> qi::lit("\""))
                     ]
                  >> *qi::space;

    std::string::const_iterator strbegin;
    strbegin = input.begin();

    bool r = qi::phrase_parse(strbegin, input.end(),
            quoted_string,
            ascii::space,
            output);
    return r && (strbegin==input.end());
}

template<>
bool
parseScalar<std::string>(const std::string& input, std::string& output) {
    std::string noquote_str;
    bool b = parseQuoted(input, noquote_str);
    if (b) {
        // parse the quote str successfully
    } else {
        // maybe no quote exists
        noquote_str = input;
    }

    output = noquote_str;

    return true;

}

template<>
bool
parseVector<std::string>(const std::string& input, 
                         std::vector<std::string>& output) {
    qi::rule<std::string::const_iterator, 
             std::vector<std::string>(), 
             ascii::space_type> vector_string;
    vector_string %= qi::lexeme[
                        (qi::lit("[")) >>
                        ( +(ascii::char_-","-"]") % qi::lit(',')) >>
                        (qi::lit("]"))
                     ];

    std::string::const_iterator strbegin;
    strbegin = input.begin();

    bool r = qi::phrase_parse(strbegin, input.end(),
            vector_string,
            ascii::space,
            output);

    if (r && (strbegin==input.end())) {

        std::for_each(output.begin(), output.end(), 
                    boost::bind(&trim< std::string >, _1, std::locale()));

        return true;
    }
    return false;
}

template<>
bool
parseDict<std::string, std::string>(const std::string& input,
                            std::map< std::string, std::string >& output) {

}

}
