#include "Property.hh"
#include "dummy.hh"

#include <boost/python.hpp>
#include <boost/noncopyable.hpp>

using namespace boost::python;

struct BasePropertyBase: public PropertyBase, wrapper<PropertyBase>
{
    BasePropertyBase(std::string k, std::string v)
        : PropertyBase(k, v) {

    }

    void modify_value(std::string new_value) {
        this->get_override("modify_value")(new_value);
    }
};


BOOST_PYTHON_MODULE(myproperty)
{
    class_<BasePropertyBase, boost::noncopyable>("PropertyBase", 
            init<std::string, std::string>())
        .def("modify_value", pure_virtual(&PropertyBase::modify_value))
        .def("key", &PropertyBase::key,
                return_value_policy<copy_const_reference>())
        .def("value", &PropertyBase::value,
                return_value_policy<copy_const_reference>())

    ;

    class_<dummy, boost::noncopyable>("dummy")
        .def("getx", &dummy::getx,
                return_value_policy<reference_existing_object>())
    ;

}
