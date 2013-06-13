#ifndef Property_hh
#define Property_hh

#include <string>
#include <sstream>

#include <iostream>

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


// API to 
// * declare property
// * set property

template<typename T>
PropertyBase* declareProperty(std::string key, T& var) {
    PropertyBase* pb = new Property<T>(key, var);
    PropertyManager::instance().add(pb);
    return pb;
}

void setProperty(PropertyBase* pb, std::string value); 
void setProperty(std::string key, std::string value);
#endif
