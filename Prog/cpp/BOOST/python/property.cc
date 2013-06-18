#include <iostream>
#include <string>
#include <boost/noncopyable.hpp>
#include "property.hh"

void
MyProperty::show() {
    bp::object s = m_value.attr("__str__")();
    std::string str = bp::extract<std::string>(s);
    std::cout << str << std::endl;
}

struct BasePropertyBase: public MyProperty, bp::wrapper<MyProperty>
{

    void modify(bp::object& new_value) {
        this->get_override("modify")(new_value);
    }
};

BOOST_PYTHON_MODULE(hello)
{
    bp::class_<BasePropertyBase, boost::noncopyable>("MyProperty")
        .def("modify", bp::pure_virtual(&MyProperty::modify))
        .def("show", &MyProperty::show)
    ;
}
