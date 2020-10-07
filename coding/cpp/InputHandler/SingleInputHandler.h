#ifndef SingleInputHandler_h
#define SingleInputHandler_h

#include "IInputHandler.h"
#include <string>
#include <list>

class SingleInputHandler: public IInputHandler {
public:
    virtual bool Buffer(DataBuffer& buffer);

    virtual bool inputs(std::list<std::string>& lists);

private:
    std::list<std::string> file_lists;

};

#endif
