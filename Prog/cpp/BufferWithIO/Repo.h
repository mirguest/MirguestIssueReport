#ifndef REPO_H
#define REPO_H

#include <list>
#include "Snapshot.h"

class Repo {
    public:
        typedef Snapshot::Index Index;
        typedef Snapshot::Path Path;

        Index get_latest(Path& path) const;
        
    private:
        std::list<Snapshot> m_all_hist;
};

#endif
