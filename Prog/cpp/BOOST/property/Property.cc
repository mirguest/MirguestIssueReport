#include "Property.hh"

void setProperty(PropertyBase* pb, std::string value) {
    pb->modify_value(value);
}

void setProperty(std::string key, std::string value) {
    PropertyBase* pb = PropertyManager::instance().get(key);

    if (pb) {
        setProperty(pb, value);
    }
}

