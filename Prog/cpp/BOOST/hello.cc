#include <string>

char const* greet()
{
       return "hello, world";
}

struct World
{
    void set(std::string msg) {
        this->msg = msg;
    }
    std::string greet() {
        return msg;
    }
    std::string msg;
};

#include <boost/python.hpp>
using namespace boost::python;

BOOST_PYTHON_MODULE(hello)
{
    def("greet", greet);

    class_<World>("World")
        .def("greet", &World::greet)
        .def("set", &World::set)
    ;
}
