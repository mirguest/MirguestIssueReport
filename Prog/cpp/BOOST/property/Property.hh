#ifndef Property_hh
#define Property_hh

#include <string>

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
    }

private:
    T& m_variable;
};


// API to 
// * declare property
// * set property

template<typename T>
PropertyBase* declareProperty(std::string key, T& var) {
    return new Property<T>(key, var);
}

void setProperty(PropertyBase* pb, std::string value) {
    pb->modify_value(value);
}

#endif
