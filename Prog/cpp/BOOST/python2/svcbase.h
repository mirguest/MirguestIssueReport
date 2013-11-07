#ifndef svcbase_h
#define svcbase_h

class svcbase {
public:
    virtual ~svcbase()=0;
    virtual bool init()=0;
};

#endif
