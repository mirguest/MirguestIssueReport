#ifndef dummy_hh
#define dummy_hh
#include <vector>
#include <map>

class MyProperty;

class dummy {
public:
    dummy();

    MyProperty* getx();
    MyProperty* gety();

    MyProperty* getvx();
    MyProperty* getvy();

    MyProperty* getmx();
    MyProperty* getmy();

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

    std::map< std::string, int > m_x;
    MyProperty* pb_m_x;
    std::map< std::string, double > m_y;
    MyProperty* pb_m_y;
};

#endif
