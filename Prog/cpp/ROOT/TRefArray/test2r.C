
void test2r() {

    TFile* f = new TFile("test2.root");

    TTree* tree_ref = (TTree*) f->Get("test_refarray");
    TRefArray* trefarray = new TRefArray;
    tree_ref -> SetBranchAddress("TRefArray", &trefarray);

    TTree* t1 = (TTree*) f->Get("test1");
    TNamed* tnamed1 = new TNamed;
    t1->SetBranchAddress("TNamed", &tnamed1);
    TTree* t2 = (TTree*) f->Get("test2");
    TNamed* tnamed2 = new TNamed;
    t2->SetBranchAddress("TNamed", &tnamed2);

    Int_t entries = t2 -> GetEntries();

    Int_t i = 0; // t1
    Int_t j = 0; // t2

    t1->GetEntry(0);
    t2->GetEntry(0);

    for (; j < entries; ++j) {
        trefarray->Clear();
        t2->GetEntry(j);

        tree_ref->GetEntry(j);
        std::cout << j << ": " << trefarray->GetEntriesFast() << std::endl;

        // print t1 and t2
        TNamed* t2n = (TNamed*) trefarray->At(1);
        if (t2n) {
            TNamed* t1n = NULL;
            // check the t1n
            t1n = (TNamed*) trefarray->At(0);
            if (!t1n) {
                t1->GetEntry(i++);
                t1n = (TNamed*) trefarray->At(0);
            }

            if (t1n) {
                std::cout << "t1: " << t1n->GetTitle() << std::endl;
            }

            std::cout << "t2: " << t2n->GetTitle() << std::endl;
        }
    }

}
