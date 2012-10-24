int getEntry(TString fn) {
  TFile* f = new TFile(fn);
  TTree* evt = f->Get("evt");

  return evt->Draw("sqrt(InitPX**2+InitPY**2+InitPZ**2)", "sqrt(edep_pos_x**2+edep_pos_y**2+edep_pos_z**2)<16000");
}

void select() {
  for (int i=0; i < 10; ++i) {
    TString fn = TString::Format("MC-Thorium-%d-5000.root", 1000+i);
    cout << fn << endl;
    cout << getEntry(fn) << endl;
  }
}
