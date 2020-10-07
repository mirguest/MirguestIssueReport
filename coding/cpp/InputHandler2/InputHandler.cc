
#include "InputHandler.h"
#include "IStream.h"

IStream*
InputHandler::get(const std::string& aliasName) {
    A2S::iterator it = a2s.find(aliasName);
    if (it == a2s.end()) {
        return 0;
    }
    return it->second;
}

bool
InputHandler::attach(const std::string& aliasName, const std::string& filepath) {
    IStream* tmpstream = get(aliasName);

    if (not tmpstream) {
        // the stream does not exist
        // create a new one
        // TODO: MAGIC HERE
        return false;
    }

    return tmpstream->attach(filepath);
}

bool
InputHandler::attachStream(const std::string& aliasName, IStream* stream) {

    IStream* tmpstream = get(aliasName);

    if (tmpstream) {
        // stream already exist
        return false;
    }

    a2s[aliasName] = stream;
    return true;
}
