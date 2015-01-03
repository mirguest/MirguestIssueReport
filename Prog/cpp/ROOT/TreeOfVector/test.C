#include "TTree.h"
#include "TFile.h"
#include <vector>

int main() {
    TFile* f = new TFile("f.root", "recreate");
    TTree* t = new TTree("t", "t");

    int steps;
    std::vector<int> trackids;
    t->Branch("steps", &steps, "steps/I");
    // t->Branch("trackids", &trackids[0], "trackids[steps]/I");
    t->Branch("trackids", &trackids);

    for (int i = 0; i < 100; ++i) {
        trackids.clear();

        for (int j = 0; j < i+10; ++j) {
            trackids.push_back(j);
        }

        steps = trackids.size();
        t->Fill();
    }

    t->Write();
    f->Write();
}
