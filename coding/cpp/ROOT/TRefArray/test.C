
void test () {

    TFile* f = new TFile("test.root", "recreate");
    TTree* t = new TTree("test", "test");
    TNamed* tnamed = new TNamed;
    t->Branch("TNamed", &tnamed);
    TTree* t2 = new TTree("test_refarray", "test_refarray");
    TRefArray* trefarray = new TRefArray;
    t2->Branch("TRefArray", &trefarray);
    for (Int_t i = 0; i < 100; ++i) {
        if (i%10==0) {
            trefarray->Clear();
        }

        TString title = TString::Format("%d", i);
        tnamed->SetTitle(title);

        t->Fill();
        trefarray->Add(tnamed);

        if (i % 10 == 9) {
            std::cout << "array size: " << trefarray->GetEntriesFast() << std::endl;
            t2->Fill();
        }
    }

    t->Write();
    t2->Write();
    f->Close();
}
