#include "HelperParse.hh"
#include <boost/spirit/include/qi.hpp>         // Parsing
#include <boost/spirit/include/phoenix.hpp>
#include <boost/fusion/adapted.hpp>

namespace Helper {

using namespace boost::spirit;

bool parseQuoted(const std::string& input, std::string& output) {
    qi::rule<std::string::const_iterator, 
             std::string(), 
             ascii::space_type> quoted_string;
    quoted_string %= qi::lexeme[
                  // single quote
                     (qi::lit("'")
                  >> +(
                        (ascii::char_("\\\'"))
                        |
                        (ascii::char_ - qi::lit("'")))
                  >> qi::lit("'"))
                     |
                  // double quote
                     (qi::lit("\"")
                  >> +(
                        (ascii::char_("\\\""))
                        |
                        (ascii::char_ - qi::lit("\"")))
                  >> qi::lit("\""))
                     ];

    std::string::const_iterator strbegin;
    strbegin = input.begin();

    bool r = qi::phrase_parse(strbegin, input.end(),
            quoted_string,
            ascii::space,
            output);
    return r;
}

}
