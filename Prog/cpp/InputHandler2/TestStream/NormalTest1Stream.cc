
#include "TestStream/NormalTest1Stream.h"

bool
NormalTest1Stream::next() {
    return true;
}

EventObject*
NormalTest1Stream::get(const std::string& objPath) {

    return 0;
}

bool
NormalTest1Stream::attach(const std::string& filepath) {
    return true;
}
