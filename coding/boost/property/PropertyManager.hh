#ifndef PropertyManager_hh
#define PropertyManager_hh

#include <map>
#include <string>

class PropertyBase;

class PropertyManager {
public:
    static PropertyManager& instance();
    bool add(PropertyBase* pb);
    PropertyBase* get(std::string key);
private:
    typedef std::map<std::string, PropertyBase*> map_obj_prop;

    map_obj_prop obj2prop;
};

#endif
