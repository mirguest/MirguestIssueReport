#ifndef InputHandler_h
#define InputHandler_h

class IStream;

class InputHandler {
public:
    IStream* get(const std::string& aliasName);

private:
    typedef std::map<std::string, IStream*> A2S;
    A2S a2s;

};

#endif
