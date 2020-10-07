#ifndef PropertyManager_hh
#define PropertyManager_hh

#include <map>
#include <string>

class MyProperty;

class PropertyManager {
public:
    static PropertyManager& instance();
    bool add(std::string objname, MyProperty* pb);
    MyProperty* get(std::string objname, std::string key);
private:
    typedef std::map<std::string, MyProperty*> MapObjProp;
    typedef std::map<std::string, MapObjProp*> MapNameObj;

    MapNameObj obj2prop;
};

#endif
