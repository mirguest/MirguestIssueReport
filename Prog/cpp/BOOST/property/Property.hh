#ifndef Property_hh
#define Property_hh

#include <string>
#include <vector>
#include <sstream>

#include <iostream>

#include <boost/algorithm/string.hpp>

#include "PropertyManager.hh"

class PropertyBase {
public:
    PropertyBase(std::string key, std::string value) 
        : m_key(key), m_value(value) {
    }
    const std::string& key() {
        return m_key;
    }
    const std::string& value() {
        return m_value;
    }
    virtual void modify_value(std::string new_value) = 0;
protected:
    std::string m_key;
    std::string m_value;
};

template<typename T>
class Property: public PropertyBase {
public:

    Property(std::string key, T& variable)
        : PropertyBase(key, ""), m_variable(variable) {

    }

    virtual void modify_value(std::string new_value) {
        // Magic is here
        // using some parser to modify the value
        std::cout << "Begin" << std::endl;
        std::stringstream ss;
        ss << new_value;
        ss >> m_variable;
        if (not ss.fail()) {
            std::cout << "ss is Good" << std::endl;
            m_value = new_value;
        }
        std::cout << "End" << std::endl;
        std::cout << "T var: " << m_variable << std::endl;

    }

private:
    T& m_variable;
};

template<typename T>
class Property< std::vector< T > >: public PropertyBase  {
public:
    Property(std::string key, std::vector< T >& variable)
        : PropertyBase(key, ""), m_variable(variable) {

    }

    virtual void modify_value(std::string new_value) {
        // Magic Here !!!
        std::cout << "In Vector." << std::endl;
        m_value = new_value;
        m_variable.clear();
        std::vector< std::string > tmp_vec;
        boost::split(tmp_vec, 
                     new_value, 
                     boost::is_any_of(" ,"));
        T tmp_var;
        for (int i=0; i < tmp_vec.size(); ++i) {
            std::stringstream ss;
            ss << tmp_vec[i];
            ss >> tmp_var;
            m_variable.push_back(tmp_var);
        }

        std::cout << "Size: " << m_variable.size() << std::endl;

    }
private:
    std::vector<T>& m_variable;
};

// API to 
// * declare property
// * set property

template<typename T>
PropertyBase* declareProperty(std::string key, T& var) {
    PropertyBase* pb = new Property<T>(key, var);
    PropertyManager::instance().add(pb);
    return pb;
}

template<typename T>
PropertyBase* declareProperty(std::string key, std::vector< T >& var) {
    PropertyBase* pb = new Property< std::vector< T > >(key, var);
    PropertyManager::instance().add(pb);
    return pb;
}

void setProperty(PropertyBase* pb, std::string value); 
void setProperty(std::string key, std::string value);
#endif
