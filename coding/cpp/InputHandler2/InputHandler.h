#ifndef InputHandler_h
#define InputHandler_h

#include <string>
#include <map>

class IStream;

class InputHandler {
public:
    IStream* get(const std::string& aliasName);

    // attach input files
    bool attach(const std::string& aliasName, const std::string& filepath);
    // attach stream (concrete stream)
    bool attachStream(const std::string& aliasName, IStream* stream);

private:
    typedef std::map<std::string, IStream*> A2S;
    A2S a2s;

};

#endif
