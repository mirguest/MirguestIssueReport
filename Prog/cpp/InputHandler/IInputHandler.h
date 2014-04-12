#ifndef IInputHandler_h
#define IInputHandler_h

#include "DataBuffer.h"

class IInputHandler {
public:
    virtual bool Buffer(DataBuffer& buffer)=0;

    virtual ~IInputHandler() {}

};

#endif
