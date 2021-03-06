
void draw(float p_theta_max_in_deg=180.) {

    TH1F* th_theta = new TH1F("theta", "theta", 180, 0, 180);
    TH1F* th_costheta = new TH1F("costheta", "costheta", 100, -1, 1);

    // float theta_max = 90. * TMath::Pi() / 180.;
    float theta_max = p_theta_max_in_deg * TMath::Pi() / 180.;

    for (int i = 0; i < 100000; ++i) {
        float theta;
        while (true) {
            theta = TMath::ACos( 1 - gRandom->Rndm() * 
                                        (1-TMath::Cos(theta_max)));
                        // * 180. / TMath::Pi();

            if (theta <= theta_max) {
                break;
            }
            std::cout << "do again" << std::endl;
            std::cout << "these two lines will not shown" << std::endl;
        }

        th_theta->Fill(theta * 180. / TMath::Pi());
        th_costheta->Fill( TMath::Cos(theta) );
    }

    new TCanvas;
    th_theta -> SetMinimum(0);
    th_theta -> Draw();
    new TCanvas;
    th_costheta -> SetMinimum(0);
    th_costheta -> Draw();
}
