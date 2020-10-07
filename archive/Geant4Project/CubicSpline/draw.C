
void draw() {

    TCanvas* c = new TCanvas;
    // double deg = TMath::Pi()/180.;
    deg = 1.;

    double s_theta[] = { 0.*deg, 9.*deg, 18.*deg, 27.*deg, 36.*deg, 45.*deg, 54.*deg, 63.*deg, 72.*deg, 81.*deg, 90.*deg, };
    double s_ce[] =    { 0.8,    0.98,   0.9,     0.87,    0.97,    0.93,    1.0,     0.77,    0.79,    0.33,    0.};

    TGraph* gr = new TGraph(11, s_theta, s_ce);
    gr -> SetTitle("Collection Efficiency");
    gr->SetMarkerStyle(24);
    gr -> GetXaxis()->SetTitle("angle(deg)");
    gr -> GetXaxis()->SetLabelSize(0.05);
    gr -> GetXaxis()->SetTitleSize(0.05);
    gr -> GetYaxis()->SetTitle("C.E.");
    gr -> GetYaxis()->SetTitleSize(0.055);
    gr -> GetYaxis()->SetTitleOffset(1.0);
    gr -> GetYaxis()->SetLabelSize(0.05);
    gr->SetLineWidth(2.2);
    gr->SetLineColor(kBlack);

    gr->Draw("AP");

    TTree* tree = new TTree("t", "t");
    tree->ReadFile("log","k:v");
    int n = tree->Draw("k*180./TMath::Pi():v", "", "goff");
    std::cout << n << std::endl;
    TGraph *g = new TGraph(n,tree->GetV1(),tree->GetV2());
    g->Draw("Lsame");
    g->SetLineWidth(2.2);
    g->SetLineColor(kBlack);

    c->Print("draw_CE.png", "png");
    c->Print("draw_CE.eps", "eps");
}
