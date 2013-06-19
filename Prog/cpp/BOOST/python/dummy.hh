#ifndef dummy_hh
#define dummy_hh
#include <vector>

class MyProperty;

class dummy {
public:
    dummy();

    MyProperty* getx();
    MyProperty* gety();

    MyProperty* getvx();
    MyProperty* getvy();

    static void exportPythonAPI();

    bool run();
private:
    int x;
    MyProperty* pb_x;
    double y;
    MyProperty* pb_y;

    std::vector<int> v_x;
    MyProperty* pb_v_x;
    std::vector<double> v_y;
    MyProperty* pb_v_y;
};

#endif
