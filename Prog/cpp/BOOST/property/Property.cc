#include "Property.hh"

void setProperty(PropertyBase* pb, std::string value) {
    pb->modify_value(value);
}

