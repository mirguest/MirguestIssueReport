#include "DataBuffer.h"
#include "SingleInputHandler.h"

bool SingleInputHandler::Buffer(DataBuffer& buffer) {

    buffer << "hello";

    return true;
}

bool SingleInputHandler::inputs(std::list<std::string>& lists) {
    std::list<std::string>::iterator it = lists.begin();

    for ( ; it != lists.end(); ++it) {
        file_lists.push_back( *it );
    }
}
