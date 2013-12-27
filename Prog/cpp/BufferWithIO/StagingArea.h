#ifndef StagingArea_h
#define StagingArea_h

#include <map>
#include <string>

class Repo;
class StagingArea {
    public:
        typedef int Index;
        typedef const std::string Path;
        typedef std::map<Path, Index> PTH2IDX;
        StagingArea(Repo* repo);
        Index read(Path& path);

        bool commit();

        bool clear();

    private:
        PTH2IDX m_buffer;

        Repo* m_repo;
};

#endif
