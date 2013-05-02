#include <string>

char const* greet()
{
       return "hello, world";
}

struct World
{
    World(std::string msg) 
        : msg(msg) {
    }
    void set(std::string msg) {
        this->msg = msg;
    }
    std::string greet() {
        return msg;
    }
    std::string msg;
};

struct Var {
    Var(std::string name)
        : name(name), value() {
    }
    std::string const name;
    float value;
};

#include <boost/python.hpp>
using namespace boost::python;

BOOST_PYTHON_MODULE(hello)
{
    def("greet", greet);

    class_<World>("World", init<std::string>())
        .def("greet", &World::greet)
        .def("set", &World::set)
    ;

    class_<Var>("Var", init<std::string>())
        .def_readonly("name", &Var::name)
        .def_readwrite("value", &Var::value)
    ;
}
