#include <iostream>
#include <boost/xpressive/xpressive.hpp>

using namespace boost::xpressive;

int main()
{
    std::string hello( "hello world!" );

    //sregex rex = sregex::compile( "(\\w+) (\\w+)!" );
    sregex rex = (s1= +_w) >> ' ' >> (s2= +_w) >> '!';
    sregex rex2 = (s1= +_w) >> ' ' >> (s1) >> '!';

    smatch what;

    if( regex_match( hello, what, rex ) )
    {
        std::cout << what[0] << '\n'; // whole match
        std::cout << what[1] << '\n'; // first capture
        std::cout << what[2] << '\n'; // second capture
    }

    smatch what2;
    std::string world("world world!");
    if (regex_match(world, what2, rex2)) {
        std::cout << what2[0] << '\n'; // whole match
        std::cout << what2[1] << '\n'; // first capture
    }

    return 0;
}
