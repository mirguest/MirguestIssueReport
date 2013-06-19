#include <iostream>
#include <string>
#include <boost/noncopyable.hpp>
#include "property.hh"
#include "dummy.hh"

void
MyProperty::show() {
    bp::object s = m_value.attr("__str__")();
    std::string str = bp::extract<std::string>(s);
    std::cout << str << std::endl;
}

MyProperty*
getProperty(std::string objname,
            std::string key) {
    MyProperty* pb = PropertyManager::instance().get(objname, key);
    return pb;
}

bool
setProperty(std::string objname,
            std::string key,
            bp::object& value) {

    MyProperty* pb = PropertyManager::instance().get(objname, key);

    if (pb == NULL) {
        // can't find the property
        return false;
    }

    pb->modify(value);

}

// Wraper for PYTHON

struct BasePropertyBase: public MyProperty, bp::wrapper<MyProperty>
{
    BasePropertyBase(std::string key, bp::object value)
        : MyProperty(key, value)
    {}

    void modify(bp::object& new_value) {
        this->get_override("modify")(new_value);
    }
};

BOOST_PYTHON_MODULE(hello)
{
    bp::class_<BasePropertyBase, boost::noncopyable>("MyProperty",
            bp::init<std::string, bp::object>())
        .def("modify", bp::pure_virtual(&MyProperty::modify))
        .def("show", &MyProperty::show)
    ;
    dummy::exportPythonAPI();
}
