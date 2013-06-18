#ifndef dummy_hh
#define dummy_hh

class MyProperty;

class dummy {
public:
    dummy();

    MyProperty* getx();
    MyProperty* gety();

    static void exportPythonAPI();

    bool run();
private:
    int x;
    MyProperty* pb_x;
    double y;
    MyProperty* pb_y;
};

#endif
