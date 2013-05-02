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

struct Num
{
    Num() 
        : x() {
    }
    float get() const {
        return x;
    }
    void set(float x) {
        this->x = x;
    }

private:
    float x;
};

struct Base {
    virtual ~Base() {}

    virtual int f () { 
        return 0;
    }
};

int vf(Base* b) {
    return b->f();
}

#include <boost/noncopyable.hpp>
#include <boost/python.hpp>
using namespace boost::python;

struct BaseWrap: Base, wrapper<Base> {
    int f() {
        if (override f = this->get_override("f"))
            return f();
        return Base::f();
    }

    int default_f() {
        return this->Base::f();
    }
};

BOOST_PYTHON_MODULE(hello)
{
    def("greet", greet);
    def("vf", vf);
    class_<World>("World", init<std::string>())
        .def("greet", &World::greet)
        .def("set", &World::set)
    ;

    class_<Var>("Var", init<std::string>())
        .def_readonly("name", &Var::name)
        .def_readwrite("value", &Var::value)
    ;

    class_<Num>("Num")
        .add_property("rovalue", &Num::get)
        .add_property("value", &Num::get, &Num::set)
    ;

    class_<BaseWrap, boost::noncopyable>("Base")
        .def("f", &Base::f, &BaseWrap::default_f)
    ;
}
