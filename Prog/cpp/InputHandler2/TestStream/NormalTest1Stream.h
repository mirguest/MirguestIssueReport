#ifndef NormalTest1Stream_h
#define NormalTest1Stream_h

#include <string>
#include "IStream.h"

class TFile;
class TTree;

class NormalTest1Stream: public IStream {
public:
    NormalTest1Stream();

    bool next();
    EventObject* get(const std::string& objPath);
    // attach input files
    bool attach(const std::string& filepath);

private:
    bool init_tree();

private:
    int m_index;
    std::string m_path;

    TFile* m_file;
    TTree* m_tree;
};

#endif
