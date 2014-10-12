
int test2() {
    
    gROOT->ProcessLine(".L libMyHit.so");

    TFile* f = new TFile("my.root", "recreate");
    TTree* t = new TTree("evt", "evt");


    TClonesArray* hits = new TClonesArray("MyHit", 1000);

    t->Branch("hits", &hits);

    for (Int_t entry = 0; entry < 1; ++entry) {
        hits->Clear();

        Int_t number = gRandom->Uniform(0, 100);
        for (Int_t i = 0; i < number; ++i) {
            //h[i] = new MyHit;
            MyHit* hit = (MyHit*)hits->ConstructedAt(i);
            hit->SetPmtID( gRandom->Uniform(0, 100) );
            hit->SetHitTime( gRandom->Rndm()*1000 );
        }

        t->Fill();
    }

    t->Write();
    f->Close();

}
