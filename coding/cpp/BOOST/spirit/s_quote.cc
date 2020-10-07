#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix.hpp>
#include <boost/fusion/adapted.hpp>

namespace qi = boost::spirit::qi;

template <typename Iterator>
struct test_parser : qi::grammar<Iterator, std::string(), qi::space_type, qi::locals<char> >
{
    test_parser() : test_parser::base_type(any_string, "test")
    {
        using namespace qi;

        quoted_string = 
               omit    [ char_("'\"") [_a =_1] ]             
            >> no_skip [ *(char_ - char_(_a))  ]
            >> lit(_a)
        ; 

        any_string = quoted_string | +qi::alnum;
    }

    qi::rule<Iterator, std::string(), qi::space_type, qi::locals<char> > quoted_string, any_string;
};

int main()
{
    test_parser<std::string::const_iterator> grammar;
    const char* strs[] = { "\"str1\"", 
                           "'str2'",
                           "'str3' trailing ok",
                           "'st\"r4' embedded also ok",
                           "str5",
                           "str6'",
                           NULL };

    for (const char** it = strs; *it; ++it)
    {
        const std::string str(*it);
        std::string::const_iterator iter = str.begin();
        std::string::const_iterator end  = str.end();

        std::string data;
        bool r = phrase_parse(iter, end, grammar, qi::space, data);

        if (r)
            std::cout << "Parsed:    " << str << " --> " << data << "\n";
        if (iter!=end)
            std::cout << "Remaining: " << std::string(iter,end) << "\n";
    }
}
