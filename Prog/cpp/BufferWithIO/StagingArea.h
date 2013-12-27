#ifndef StagingArea_h
#define StagingArea_h

#include <map>
#include <string>

class StagingArea {
    public:
        typedef int Index;
        typedef const std::string Path;
        Index read(Path& path);

        bool clear();

    private:
        typedef std::map<Path, Index> PTH2IDX;
        PTH2IDX m_buffer;
};

#endif
