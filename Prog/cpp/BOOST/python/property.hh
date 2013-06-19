#ifndef property_hh
#define property_hh

#include <boost/python.hpp>
#include <boost/python/stl_iterator.hpp>
#include <string>
#include <vector>
#include <map>

namespace bp = boost::python;

class MyProperty {
public:
    MyProperty(std::string key, bp::object value)
        : m_key(key), m_value(value)
    {}
    virtual void modify(bp::object& other) = 0;
    void show(); 

    const std::string& key() {
        return m_key;
    }


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
        bp::stl_input_iterator<T> begin(other), end;
        m_var.clear();
        m_var.insert(m_var.end(), begin, end);
        m_value = other;

    }
private:
    std::vector< T >& m_var;
};

// Map
template<typename Key, typename T>
class Property< std::map< Key, T > >: public MyProperty {
public:
    Property(std::string key, std::map< Key, T >& obj)
        : MyProperty(key, bp::dict())
          , m_var(obj)
    {
        for(typename std::map< Key, T >::iterator it=obj.begin();
                it != obj.end();
                ++it) {
            m_value[ it->first ] = it->second;
        }
    }
    void modify(bp::object& other) {
        bp::extract<bp::dict> other_dict_check(other);
        m_var.clear();
        if (other_dict_check.check()) {
            bp::dict other_dict = other_dict_check();
            bp::list iterkeys = (bp::list)other_dict.iterkeys();
            for(bp::ssize_t i = 0; i < bp::len(iterkeys); ++i) {
                bp::object key_obj = iterkeys[i];
                bp::extract<Key> key_check(key_obj);
                if (key_check.check()) {

                } else {
                    // TODO: raise Error?
                    continue;
                }
                bp::object value_obj = other_dict[key_obj];
                bp::extract<T> value_check(value_obj);
                if (value_check.check()) {

                } else {
                    // TODO: raise Error?
                    continue;
                }

                // setting the map
                m_var[ key_check() ] = value_check();
            }
        } else {

        }

    }
private:
    std::map< Key, T >& m_var;
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

template<typename Key, typename T>
MyProperty* declareProperty(std::string key, std::map< Key, T >& var) {
    MyProperty* pb = new Property< std::map< Key, T > >(key, var);
    return pb;
}

#endif
