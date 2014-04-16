#ifndef IStream_h
#define IStream_h

class EventObject;

class IStream {
public:
    virtual bool next() = 0;
    virtual EventObject* get(const std::string& objPath) = 0;

};

#endif
