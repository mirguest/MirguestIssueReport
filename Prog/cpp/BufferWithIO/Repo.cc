#include "Repo.h"

Repo::Index
Repo::get_latest(Path& path) const
{
    // find the snapshot first
    // make sure the list have some elements
    if ( m_all_hist.size() == 0 ) {
        // this is a empty Repo
        return -1;
    }

    return m_all_hist.back().get(path);
}
