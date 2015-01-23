#include <string>
#include <TNtuple.h>
#include <TCanvas.h>
#include <TRandom.h>
struct Params {
    std::string name;
    double eff1;
    double eff2;

    int evt;
    int pes;

    Params () {
        name = "test";
        eff1 = 0.35;
        eff2 = 1.;

        evt = 100000;
        pes = 10000;
    }
};

int randp(const Params& param) {
    int cnt = 0;
    for (int i = 0; i < param.pes; ++i) {
        // make first decisioin
        double r = gRandom->Rndm();
        if ( r < param.eff1) {
            // make second decisioin
            r = gRandom->Rndm();
            if (r < param.eff2) {
                // hit
                ++cnt;
            }
        } else {

        }
    }

    return cnt;
}

void do_exp(const Params& param) {
    TNtuple* t = new TNtuple(param.name.c_str(),param.name.c_str(), "totalpe");
    for (int i = 0; i < param.evt; ++i) {
        t->Fill(randp(param));
    }
    new TCanvas;
    t->Draw("totalpe");
}

void randcmp() {

    Params* params1 = new Params();
    Params* params2 = new Params();
    params2->name = "test2";
    params2->eff1 = 0.35/0.9;
    params2->eff2 = 0.9;

    do_exp(*params1);
    do_exp(*params2);

}
