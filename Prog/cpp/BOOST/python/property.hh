#ifndef property_hh
#define property_hh

#include <boost/python.hpp>
#include <string>
#include <vector>

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

// Scalar

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

// Vector

template<typename T>
class Property< std::vector< T > >: public MyProperty {
public:
    Property(std::string key, std::vector< T >& obj)
        : MyProperty(key, bp::list())
          , m_var(obj)
    {
        for(typename std::vector<T>::iterator it = obj.begin();
                it != obj.end();
                ++it) {
            m_value.attr("append")(*it);
        }
    }
    void modify(bp::object& other) {
        bp::list tmp_var;

    }
private:
    std::vector< T >& m_var;
};

// API
template<typename T>
MyProperty* declareProperty(std::string key, T& var) {
    MyProperty* pb = new Property<T>(key, var);
    return pb;
}

template<typename T>
MyProperty* declareProperty(std::string key, std::vector<T>& var) {
    MyProperty* pb = new Property< std::vector<T> >(key, var);
    return pb;
}

#endif
