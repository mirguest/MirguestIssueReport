#include "Snapshot.h"

Snapshot::Snapshot()
    : m_is_committed(false)
{

}

bool
Snapshot::add(Snapshot::Path& path, Snapshot::Index index)
{
    // check can commit
    if (m_is_committed) {
        return false;
    }
    // If there are conficts, return false;
    PTH2IDX::iterator it = m_snapshot.find(path);

    if (it == m_snapshot.end()) {
        // not found, append this entry
        m_snapshot[path] = index;
        return true;
    }
    // TODO
    // If the index are different, check!
    if (it->second < index) {
        m_snapshot[path] = index;
    } else {
        return false;
    }
    return true;
}

Snapshot::Index 
Snapshot::get(Path& path) const{
    // Only after the Snapshot commit, we can get the data.
    if (not m_is_committed) {
        return -1;
    }

    PTH2IDX::const_iterator it = m_snapshot.find(path);
    if (it != m_snapshot.end()) {
        // if found, return this entry
        return it->second;
    } 

    return -1;
}

bool
Snapshot::commit() {
    if (not m_is_committed) {
        m_is_committed = true;
        return true;
    }
    return false;
}
