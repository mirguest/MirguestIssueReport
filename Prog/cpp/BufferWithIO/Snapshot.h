#ifndef Snapshot_h
#define Snapshot_h
#include <string>
#include <map>

class Snapshot {
    public:
        typedef int Index;
        typedef const std::string Path;

        Snapshot();

        bool add(Path& path, Index);
        Index get(Path&) const;
        bool commit();

    private:
        typedef std::map<Path, Index> PTH2IDX;
        PTH2IDX m_snapshot;
        bool m_is_committed;

};

#endif
