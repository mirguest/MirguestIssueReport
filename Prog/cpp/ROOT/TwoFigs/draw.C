
void draw() {

    TCanvas* c = new TCanvas;
    TH1F* th1f = new TH1F("th","th", 100, -5, 5);
    th1f->FillRandom("gaus");
    th1f->Draw();

    TPad* pad2 = new TPad("pad2","This is pad2",0.05,0.52,0.55,0.97);
    pad2->Draw();
    pad2->cd();
    TH1F* th1f2 = new TH1F("th2","th2", 100, -5, 5);
    th1f2->FillRandom("gaus");
    th1f2->Draw();
}
