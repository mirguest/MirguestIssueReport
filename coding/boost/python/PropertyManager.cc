#include "PropertyManager.hh"
#include "property.hh"

PropertyManager&
PropertyManager::instance() {
    static PropertyManager pm;
    return pm;
}

bool
PropertyManager::add(std::string objname, MyProperty* pb) {
    // find object first.
    MapNameObj::iterator it;
    it = obj2prop.find(objname);
    if (it == obj2prop.end()) {
        // The object does not exist;
        obj2prop[objname] = new MapObjProp();
    }
    // find the property of the object.
    MapObjProp::iterator it2;
    it2 = (*obj2prop[objname]).find(pb->key());
    if (it2 == (*obj2prop[objname]).end()) {
        // The property does not exist;
        (*obj2prop[objname])[pb->key()] = pb;
    }
    return true;
}

MyProperty*
PropertyManager::get(std::string objname, std::string key) {
    // find object first
    MapNameObj::iterator it;
    it = obj2prop.find(objname);
    if (it == obj2prop.end()) {
        // can't find object
        return NULL;
    }
    // find the property of the object.
    MapObjProp::iterator it2;
    it2 = (*obj2prop[objname]).find(key);
    if (it2 == (*obj2prop[objname]).end()) {
        // can't find the property
        return NULL;
    }
    return (*obj2prop[objname])[key];

}
