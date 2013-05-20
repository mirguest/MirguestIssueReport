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

template <typename T> class property {
private:
    T value;
public:
    T & operator = (const T &i) {
        return value = i;
    }
    // This template class member function template serves the purpose to make
    // typing more strict. Assignment to this is only possible with exact identical
    // types.
    template <typename T2> T2 & operator = (const T2 &i) {
        T2 &guard = value;
        throw guard; // Never reached.
    }
    operator T const & () const {
        return value;
    }
};

#define PropertyGetterName(name) \
    get_##name

#define PropertyGetter(Type, Name) \
public: \
    const Type PropertyGetterName(Name) () { \
        return m_##Name; \
    }

#define PropertyDeclare(Type, Name) \
private: \
    Type m_##Name;

#define Property(Type, Name) \
    PropertyDeclare(Type, Name) \
    PropertyGetter(Type, Name)

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

    property<float> y;

    Property(float, z)

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
        .add_property("z", &Num::PropertyGetterName(z))
    ;

    class_<BaseWrap, boost::noncopyable>("Base")
        .def("f", &Base::f, &BaseWrap::default_f)
    ;
}
