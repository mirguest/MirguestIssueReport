
void read() {
    TFile* f = new TFile("test.root");
    TTree* t = (TTree*) f->Get("tree");

    TNamed* tnamed = 0;
    t->SetBranchAddress("tnamed", &tnamed);

    TNamed* myarray[10000];

    for (Int_t i = 0; i < 10000; ++i) {
        tnamed = 0;
        t->GetEntry(i);

        myarray[i] = tnamed;
    }

    for (Int_t i = 0; i < 10000; ++i) {

        if (i % 100 == 0) {
            std::cout << myarray[i]->GetTitle() << std::endl;
        }
    }
}
