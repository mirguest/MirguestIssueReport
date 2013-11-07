#ifndef svcimpl_h
#define svcimpl_h

#include "svcbase.h"
#include "interface.h"

class svcimpl: public svcbase, public interface {
public:
    svcimpl() : svcbase() {}
    bool init();
    int xxx();

};
#endif
