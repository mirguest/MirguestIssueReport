#ifndef dummy_hh
#define dummy_hh

class PropertyBase;

class dummy {
public:
    dummy() ;

    PropertyBase* getx();
    PropertyBase* gety();

    static void exportPythonAPI();

private:
    int x;
    PropertyBase* pb_x;

    float y;
    PropertyBase* pb_y;
};

#endif
