#ifndef property_hh
#define property_hh

#include <boost/python.hpp>
#include <string>

namespace bp = boost::python;

class MyProperty {
public:
    MyProperty(std::string key, bp::object value)
        : m_key(key), m_value(value)
    {}
    virtual void modify(bp::object& other) = 0;
    void show(); 


protected:
    std::string m_key;
    bp::object m_value;

};

template<typename T>
class Property: public MyProperty {
public:
    Property(std::string key, T& obj)
        : MyProperty(key, bp::object(obj))
    {}
    void modify(bp::object& other) {

    }
};

#endif
