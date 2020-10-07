
void testr() {

    TFile* f = new TFile("test.root");

    TTree* t2 = (TTree*) f->Get("test_refarray");
    TRefArray* trefarray = new TRefArray;
    t2->SetBranchAddress("TRefArray", &trefarray);

    TTree* t = (TTree*) f->Get("test");
    TNamed* tnamed = new TNamed;
    t->SetBranchAddress("TNamed", &tnamed);

    Int_t entries = t2->GetEntries();
    for (Int_t i = 0; i < entries; ++i) {
        t2->GetEntry(i);
        std::cout << "index: " << i << std::endl;
        std::cout << "array size: " << trefarray->GetEntriesFast() << std::endl;
        for (Int_t j = 0; j < trefarray->GetEntriesFast(); ++j) {

            t->GetEntry(i*10+j);

            TNamed* tn = (TNamed*)trefarray->At(j);
            if (tn) {
                std::cout << tn->GetTitle() << std::endl;
            }
        }
    }
}
