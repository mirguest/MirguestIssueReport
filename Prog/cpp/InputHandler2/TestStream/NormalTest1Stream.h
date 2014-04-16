#ifndef NormalTest1Stream_h
#define NormalTest1Stream_h

#include "IStream.h"

class NormalTest1Stream: public IStream {
public:
    bool next();
    EventObject* get(const std::string& objPath);
    // attach input files
    bool attach(const std::string& filepath);

};

#endif
