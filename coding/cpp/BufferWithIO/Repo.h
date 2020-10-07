#ifndef REPO_H
#define REPO_H

#include <list>
#include "Snapshot.h"
#include "StagingArea.h"

class Repo {
    public:
        typedef Snapshot::Index Index;
        typedef Snapshot::Path Path;

        Index get_latest(Path& path) const;

        bool create_snapshot(StagingArea::PTH2IDX& buffer);
        
    private:
        std::list<Snapshot> m_all_hist;
};

#endif
