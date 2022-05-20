
void write() {
    TFile* f = new TFile("test.root", "recreate");
    TTree* t = new TTree("tree", "tree");
    Int_t x;
    TNamed* tnamed = 0;
    t->Branch("x", &x, "x/I");
    t->Branch("tnamed", &tnamed);

    for (Int_t i = 0; i < 10000; ++i) {
        x = i % 100;
        TString title = TString::Format("%d", i);
        tnamed->SetTitle(title);
        t->Fill();
    }

    t->Write();
    f->Close();

}
