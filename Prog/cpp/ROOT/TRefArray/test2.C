
void test2() {

    TFile* f = new TFile("test2.root", "recreate");
    TTree* t1 = new TTree("test1", "test1");
    TNamed* tnamed1 = new TNamed;
    t1->Branch("TNamed", &tnamed1);
    TTree* t2 = new TTree("test2", "test2");
    TNamed* tnamed2 = new TNamed;
    t2->Branch("TNamed", &tnamed2);

    TTree* tree_ref = new TTree("test_refarray", "test_refarray");
    TRefArray* trefarray = new TRefArray;
    tree_ref->Branch("TRefArray", &trefarray);

    Int_t i = 0; // for t1
    Int_t j = 0; // for t2
    for (; i < 10; ++i) {
        TString title1 = TString::Format("tname1::%d", i);
        tnamed1 -> SetTitle(title1);
        t1->Fill();

        for (Int_t dup = 0; dup < 2; ++dup) {
            TString title2 = TString::Format("tname2::%d::%d", i, j);
            tnamed2->SetTitle(title2);
            
            t2->Fill();
            ++j;

            trefarray->Clear();

            trefarray->Add(tnamed1);
            trefarray->Add(tnamed2);

            tree_ref->Fill();

        }
    }

    t1->Write();
    t2->Write();
    tree_ref->Write();
    f->Close();
    
}
