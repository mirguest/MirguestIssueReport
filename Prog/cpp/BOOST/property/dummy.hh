#ifndef dummy_hh
#define dummy_hh

#include <vector>

class PropertyBase;

class dummy {
public:
    dummy() ;

    PropertyBase* getx();
    PropertyBase* gety();
    PropertyBase* getz();

    static void exportPythonAPI();

    bool run();

private:
    int x;
    PropertyBase* pb_x;

    float y;
    PropertyBase* pb_y;

    std::vector<int> z;
    PropertyBase* pb_z;
};

#endif
