
void draw() {

    double deg = TMath::Pi()/180.;

    TTree* t = new TTree("t", "t");
    t->ReadFile("log","k:v");
    t->Draw("v:k");

    double s_theta[] = { 0.*deg, 9.*deg, 18.*deg, 27.*deg, 36.*deg, 45.*deg, 54.*deg, 63.*deg, 72.*deg, 81.*deg, 90.*deg, };
    double s_ce[] =    { 0.8,    0.98,   0.9,     0.87,    0.97,    0.93,    1.0,     0.77,    0.79,    0.33,    0.};

    TGraph* gr = new TGraph(11, s_theta, s_ce);
    gr->SetMarkerStyle(24);
    gr->Draw("Psame");
}
