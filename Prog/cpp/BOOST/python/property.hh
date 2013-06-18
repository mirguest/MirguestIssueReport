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
          , m_var(obj)
    {}
    void modify(bp::object& other) {
        bp::extract<T> tmp_var(other);
        if (tmp_var.check()) {
            // check the value is ok
            m_var = tmp_var();
            m_value = other;
        } else {

        }
    }
private:
    T& m_var;
};

// API
template<typename T>
MyProperty* declareProperty(std::string key, T& var) {
    MyProperty* pb = new Property<T>(key, var);
    return pb;
}

#endif
