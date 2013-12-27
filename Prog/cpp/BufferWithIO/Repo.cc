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

bool
Repo::create_snapshot(StagingArea::PTH2IDX& buffer)
{
    Snapshot ss;
    if ( m_all_hist.size() ) {
        ss.load( m_all_hist.back() );
    }

    StagingArea::PTH2IDX::const_iterator it;

    for (it = buffer.begin(); it != buffer.end(); ++it ) {
        if (ss.add( it->first, it->second )) {
            continue;
        } else {
            return false;
        }
    }

    ss.commit();

    // finally, save this snapshot
    m_all_hist.push_back(ss);
}
