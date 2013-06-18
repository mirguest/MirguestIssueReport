#include <iostream>
#include <string>
#include "property.hh"

void
MyProperty::modify(bp::object& other) {
    m_value = other;
}

void
MyProperty::show() {
    bp::object s = m_value.attr("__str__")();
    std::string str = bp::extract<std::string>(s);
    std::cout << str << std::endl;
}

BOOST_PYTHON_MODULE(hello)
{
    bp::class_<MyProperty>("MyProperty")
        .def("modify", &MyProperty::modify)
        .def("show", &MyProperty::show)
    ;
}
