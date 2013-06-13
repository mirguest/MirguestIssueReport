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
    ;

    class_<dummy, boost::noncopyable>("dummy")
    ;

}
