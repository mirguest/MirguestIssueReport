#ifndef svcbase_h
#define svcbase_h

class svcbase {
public:
    svcbase();
    virtual ~svcbase();
    virtual bool init()=0;
};

#endif
