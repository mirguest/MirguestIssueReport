
#include "InputHandler.h"

IStream*
InputHandler::get(const std::string& aliasName) {
    A2S::iterator it = a2s.find(aliasName);
    if (it == a2s.end()) {
        return 0;
    }
    return it->second;
}
