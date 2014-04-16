#include <iostream>
#include "TestStream/NormalTest1Stream.h"
#include "TestStream/NormalTest1EvtObj.h"

#include "TFile.h"
#include "TTree.h"
#include "TSystem.h"

NormalTest1Stream::NormalTest1Stream() {
    m_index = -1;
    m_path = "";

    m_file = 0;
    m_tree = 0;
    m_evtobj = 0;
}

bool
NormalTest1Stream::next() {
    ++m_index;
    return true;
}

EventObject*
NormalTest1Stream::get(const std::string& objPath) {
    if (not m_tree) {
        return 0;
    }
    m_tree->GetEntry(m_index);
    NormalTest1EvtObj* evtobj = new NormalTest1EvtObj;
    evtobj->setEvtID( m_tree_cache.evtID );

    return evtobj;
}

bool
NormalTest1Stream::attach(const std::string& filepath) {
    std::cout << __LINE__ << " " << filepath << std::endl;
    m_path = filepath;
    return init_tree();
}

bool
NormalTest1Stream::init_tree() {
    gSystem->Load("libTree.so");
    m_file = new TFile(m_path.c_str());

    if (not m_file) {
        return false;
    }

    m_tree = (TTree*) m_file->Get("evt");
    if (not m_tree) {
        return false;
    }

    m_tree->SetBranchAddress("evtID", &m_tree_cache.evtID);
    return true;
}
