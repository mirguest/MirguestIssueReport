#include "StagingArea.h"

StagingArea::Index
StagingArea::read(StagingArea::Path& path) {

    // if exists in the buffer, just return the Index
    //
    PTH2IDX::iterator it = m_buffer.find(path);
    if (it != m_buffer.end()) {
        return it->second;
    }

    // if not exists, load the data from Repo

    return 0;
}

bool
StagingArea::clear() {
    m_buffer.clear();
    return true;
}
