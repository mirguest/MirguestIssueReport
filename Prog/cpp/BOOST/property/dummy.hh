#ifndef dummy_hh
#define dummy_hh

class PropertyBase;

class dummy {
public:
    dummy() ;

    PropertyBase* getx();

private:
    int x;
    PropertyBase* pb_x;
};

#endif
