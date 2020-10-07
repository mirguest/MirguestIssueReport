#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <functional>
#include <boost/bind.hpp>

int main()
{

    std::vector<std::string> vs;
    vs.push_back("hello");
    vs.push_back("world");
    vs.push_back("lintao");

    std::vector<int> vi;
    vi.resize(vs.size());
    std::transform(
            vs.begin(), vs.end(),
            vi.begin(),
            boost::bind(
                &std::string::size, _1
                ));

    for(std::vector<int>::iterator it=vi.begin();
            it != vi.end(); ++it) {
        std::cout << *it << std::endl;
    }

    std::vector<std::string>::iterator itmax = std::max_element(
            vs.begin(), vs.end(),
            boost::bind(
                std::less<int>(),
                boost::bind(&std::string::size, _1),
                boost::bind(&std::string::size, _2)
                )
            );
    std::cout << *itmax << std::endl;
            
}
