#ifndef IStream_h
#define IStream_h

#include <string>

class EventObject;

class IStream {
public:
    virtual bool next() = 0;
    virtual EventObject* get(const std::string& objPath) = 0;
    // attach input files
    virtual bool attach(const std::string& filepath)=0;

};

#endif
