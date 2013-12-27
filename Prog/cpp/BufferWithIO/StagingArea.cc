#include "StagingArea.h"
#include "Repo.h"

StagingArea::StagingArea(Repo* repo)
    : m_repo(repo)
{

}

StagingArea::Index
StagingArea::read(StagingArea::Path& path) {

    // if exists in the buffer, just return the Index
    //
    PTH2IDX::iterator it = m_buffer.find(path);
    if (it != m_buffer.end()) {
        return it->second;
    }

    // if not exists, load the data from Repo
    Index result = m_repo->get_latest(path);
    if ( result == -1 ) {
        m_buffer[path] = -1;
    } else {
        // increase the count
        m_buffer[path] = result + 1;
    }

    return m_buffer[path];
}

bool
StagingArea::clear() {
    m_buffer.clear();
    return true;
}

bool
StagingArea::commit() {
    m_repo->create_snapshot( m_buffer );
    clear();
}

