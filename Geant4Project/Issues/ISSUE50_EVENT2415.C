
void ISSUE50_EVENT2415() {
  TFile* f = new TFile("MC-Thorium-1002-5000.root");
  TTree* evt = f -> Get("evt");

  Int_t evtID;
  Int_t initNParticles;

  Int_t initPDGID[100];
  Float_t edepTotal[100];

  Int_t nPhotons;
  Int_t peTrackID[2000000];

  evt -> SetBranchAddress("evtID", &evtID);
  evt -> SetBranchAddress("nInitParticles", &initNParticles);
  evt -> SetBranchAddress("InitPDGID", initPDGID);
  evt -> SetBranchAddress("edep_total", edepTotal);

  evt -> SetBranchAddress("nPhotons", &nPhotons);
  evt -> SetBranchAddress("PETrackID", peTrackID);


  evt -> GetEntry(2415);

  cout << evtID << endl;
  cout << initNParticles << endl;
  // Loop the Init Particles.
  for (Int_t i=0; i < initNParticles; ++i) {
    cout << initPDGID[i] << endl;
    cout << edepTotal[i] << endl;
  }
  // It seems The last track is the ZERO one.
  //
  for (Int_t i=0; i < nPhotons; ++i) {
    if ( peTrackID[i] == 10) {
      cout << peTrackID[i] << " ";
    }
  }
  cout << endl;

}
