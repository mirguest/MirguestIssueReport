#include "PropertyManager.hh"
#include "Property.hh"

PropertyManager&
PropertyManager::instance() {
    static PropertyManager pm;
    return pm;
}

bool
PropertyManager::add(PropertyBase* pb) {
    map_obj_prop::iterator it;
    it = obj2prop.find(pb->key());
    if (it == obj2prop.end()) {
        obj2prop[pb->key()] = pb;
    }
}

PropertyBase*
PropertyManager::get(std::string key) {
    map_obj_prop::iterator it;
    it = obj2prop.find(key);
    if (it == obj2prop.end()) {
        return NULL;
    }
    return obj2prop[key];

}
