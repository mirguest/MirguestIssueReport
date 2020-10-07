
void gen_tree() {
    TFile* f = TFile::Open("evt_with_alias.root", "RECREATE"); 
    TTree* tree = new TTree("evt", "Event with Alias");
    float x,y,z;

    tree->Branch("x", &x, "x/F");
    tree->Branch("y", &y, "y/F");
    tree->Branch("z", &z, "z/F");

    for (int i = 0; i < 100; ++i) {
        x = gRandom->Rndm();
        y = gRandom->Rndm();
        z = gRandom->Rndm();

        tree->Fill();
    }

    // Create Alias for tree
    // So that after re-open the file, we can still use the alias.
    tree->SetAlias("perp", "(x**2+y**2)**0.5");
    tree->SetAlias("mag", "(perp**2+z**2)**0.5");

    tree->Write();
    f->Close();
}
