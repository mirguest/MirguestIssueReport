#ifndef MuonFastSimVoxelHelper_hh
#define MuonFastSimVoxelHelper_hh

#include <TString.h>
#include <TTree.h>
#include <TFile.h>
#include <TVector3.h>
#include <TProfile2D.h>
#include <TH1I.h>
#include <TMath.h>
#include <TRandom.h>

#include <iostream>
#include <vector>

namespace VoxelMethodHelper {
struct Geom {

    Geom() {
        PMT_x.clear();
        PMT_y.clear();
        PMT_z.clear();

    }

    void load() {
        const char* preDir = gDirectory->GetPath();
        TFile* f = TFile::Open(m_geom_file.c_str());
        gDirectory->cd(preDir);
        if (!f) { return; }

        TTree* t = dynamic_cast<TTree*>(f->Get("geom"));
        if (!t) { return; }

        int pmttype;
        float x,y,z;
        t->SetBranchAddress("pmttype", &pmttype);
        t->SetBranchAddress("x", &x);
        t->SetBranchAddress("y", &y);
        t->SetBranchAddress("z", &z);

        for (int i = 0; i < t->GetEntries(); ++i) {
            t->GetEntry(i);
            // only select 20inch PMT
            if (pmttype != 20) {
                continue;
            }
            PMT_type.push_back(pmttype);
            PMT_x.push_back(x);
            PMT_y.push_back(y);
            PMT_z.push_back(z);

            PMT_pos.push_back(TVector3(x,y,z));
        }
    }

    void info() {
        std::cout << "summary of geom service: " << std::endl;
        std::cout << "size of x: " << PMT_x.size() << std::endl;
        std::cout << "size of y: " << PMT_y.size() << std::endl;
        std::cout << "size of z: " << PMT_z.size() << std::endl;
    }

    std::string m_geom_file;
    std::vector<int> PMT_type;
    std::vector<double> PMT_x;
    std::vector<double> PMT_y;
    std::vector<double> PMT_z;
    std::vector<TVector3> PMT_pos;
};

// * 2015.11.26 update the dim of hit time.
// * 2015.11.30 use flags to switch r3 or r, cos(theta) or theta
struct HitTimeLoader {
    enum Mode {
        kUnknown = 0,
        kR3 = 1, kR = 2,
        kCosTheta = 3, kTheta = 4
    };
    HitTimeLoader() {
        f_single = 0;
        xmode = kR;
        ymode = kTheta;
        bins_costheta = 0;
        bins_theta = 0;
        bins_r3 = 0;
        bins_r = 0;

        xbinnum = 200;
        ybinnum = 180;

        // it will load all by default
        m_lazy_loading = false;
    }

    void load() {
        const char* preDir = gDirectory->GetPath();
        f_single = TFile::Open(m_single_filename);
        gDirectory->cd(preDir);
        if (!f_single) { return; }

        std::cout << "==== Loading Data: " << std::endl;
        // TODO load axis object and bin numbers from file
        if (f_single->Get("bins_r3")) {
            bins_r3 = dynamic_cast<TAxis*>(f_single->Get("bins_r3"));
            xmode = kR3;
            xbinnum = bins_r3->GetNbins();
            std::cout << "===== Load bins_r3 (" << xbinnum << ") " << std::endl;
        } else if (f_single->Get("bins_r")) {
            bins_r = dynamic_cast<TAxis*>(f_single->Get("bins_r"));
            xmode = kR;
            xbinnum = bins_r->GetNbins();
            std::cout << "===== Load bins_r (" << xbinnum << ") " << std::endl;
        } else {
            bins_r3 = new TAxis(xbinnum, 0, 5600);
            bins_r = new TAxis(xbinnum, 0, 17.7);
        }

        if (f_single->Get("bins_theta")) {
            bins_theta = dynamic_cast<TAxis*>(f_single->Get("bins_theta"));
            ymode = kTheta;
            ybinnum = bins_theta->GetNbins();
            std::cout << "===== Load bins_theta (" << ybinnum << ") " << std::endl;
        } else if (f_single->Get("bins_costheta")) {
            bins_costheta = dynamic_cast<TAxis*>(f_single->Get("bins_costheta"));
            ymode = kCosTheta;
            ybinnum = bins_costheta->GetNbins();
            std::cout << "===== Load bins_costheta (" << ybinnum << ") " << std::endl;
        } else {
            bins_costheta = new TAxis(ybinnum, -1, 1.01);
            bins_theta = new TAxis(ybinnum, 0, 180.01*TMath::Pi()/180.);
        }

        // lazy load
        for (int i = 0; i < xbinnum; ++i) {
            for (int j = 0; j < ybinnum; ++j) {
                TH1F* h = 0;
                if (!m_lazy_loading) {
                    TString th_name = TString::Format("%d", i*ybinnum+j);
                    h = dynamic_cast<TH1F*>(f_single->Get(th_name));
                }
                ths_tres.push_back(h);
            }
        }
        std::cout << "==== Total load " << ths_tres.size() << std::endl;
    }

    TH1F* get_hist(Int_t binx, Int_t biny) {
        // binx: [1, xbinnum]
        // biny: [1, ybinnum]
        if (binx<1) { binx = 1; }
        else if (binx > xbinnum) { binx = xbinnum;}
        if (biny<1) { biny = 1; }
        else if (biny > ybinnum) { biny = ybinnum;}

        int idx = (binx-1)*ybinnum+(biny-1);

        TH1F* h = ths_tres[idx];
        if (!h) {
            TString th_name = TString::Format("%d", idx);
            h = dynamic_cast<TH1F*>(f_single->Get(th_name));
            ths_tres[idx] = h;
        }
        return h;
    }
    Double_t get_hittime_mean(Int_t binx, Int_t biny) {
        TH1F* h = get_hist(binx, biny);
        return h->GetMean();
    }

    Double_t get_hittime_delta(Int_t binx, Int_t biny) {
        TH1F* h = get_hist(binx, biny);
        Double_t hittime = h->GetRandom();
        hittime -= h->GetMean();
        return hittime;
    }

    Double_t get_hittime_all(Int_t binx, Int_t biny) {
        TH1F* h = get_hist(binx, biny);
        Double_t hittime = h->GetRandom();

        return hittime;

    }

    Double_t get_hittime(Float_t r, Float_t theta, int mode) {
        Int_t binx = get_bin_x(r);
        Int_t biny = get_bin_y(theta);
        return get_hittime(binx, biny, mode);
    }
    // mode:
    // * 0, mean + delta
    // * 1, mean
    // * 2, delta
    Double_t get_hittime(Int_t binx, Int_t biny, int mode) {
        // hit time = tmean + tres
        Double_t hittime = 0.0;
        if (mode == 0) {
            hittime = get_hittime_all(binx,biny);
        } else if (mode == 1) {
            hittime = get_hittime_mean(binx,biny);
        } else if (mode == 2) {
            hittime = get_hittime_delta(binx,biny);
        }

        return hittime;
    }

    Int_t get_bin_x(Float_t r) {
        Int_t binx = 1;
        if (xmode == kR3) {
            binx = bins_r3->FindBin(TMath::Power(r, 3));
        } else if (xmode == kR) {
            binx = bins_r->FindBin(r);
        } else {
            std::cerr << "unknown mode" << std::endl;
        }
        return binx;
    }

    Int_t get_bin_y(Float_t theta) {
        Int_t biny = 1;
        if (ymode == kCosTheta) {
            biny = bins_costheta->FindBin(TMath::Cos(theta));
        } else if (ymode == kTheta) {
            biny = bins_theta->FindBin(theta);
        } else {
            std::cerr << "unknown mode" << std::endl;
        }
        return biny;
    }

    TString m_single_filename;

    TFile* f_single;
    std::vector<TH1F*> ths_tres;

    // flags
    Mode xmode; // kR3 or kR
    Mode ymode; // kCosTheta or kTheta

    Int_t xbinnum;
    Int_t ybinnum;
    TAxis* bins_r3;
    TAxis* bins_r;
    TAxis* bins_costheta;
    TAxis* bins_theta;

    bool m_lazy_loading;

};

// * 2015.11.25 update the dim of ths_npe to 100*180
struct NPELoader {
    NPELoader() {
        bins_theta = 0;
        bins_r3 = 0;

        // not implemented yet
        m_lazy_loading = false;
    }

    void load() {
        // TFile* f_npe = TFile::Open(m_filename_npe);
        // if (!f_npe) { return; }
        // m_prof_npe = dynamic_cast<TProfile2D*>(f_npe->Get("npehprof"));
        // if (!m_prof_npe) { return; }
        // m_prof2_npe = dynamic_cast<TProfile2D*>(f_npe->Get("npehprof2"));
        // if (!m_prof2_npe) { return; }

        const char* preDir = gDirectory->GetPath();
        TFile* f_npe_single = TFile::Open(m_filename_npe_single);
        gDirectory->cd(preDir);
        bins_theta = new TAxis(180, 0, 180.01*TMath::Pi()/180.);
        bins_r3 = new TAxis(100, 0, 5600);
        if (!f_npe_single) { return; }
        for (int i = 0; i < 100; ++i) {
            for (int j = 0; j < 180; ++j) {
                TString th_name = TString::Format("%d", i*180+j);
                ths_npe[i][j] = dynamic_cast<TH1F*>(f_npe_single->Get(th_name));
                assert(ths_npe[i][j]);
            }
        }
    }

    Int_t get_npe(Float_t r, Float theta) {
        Int_t binx = bins_r3->FindBin(TMath::Power(r, 3));
        Int_t biny = bins_theta->FindBin(theta);
        return get_npe(binx, biny);
    }

    Int_t get_npe(Int_t binx, Int_t biny) {
        Int_t npe_from_single = 0;
        if (1<=binx and binx<=100 and 1<=biny and biny<=180) {
            TH1F* th = ths_npe[binx-1][biny-1];
            npe_from_single = th->GetRandom();
        } else if (binx==1 and (biny<1 or biny>180)) {
            biny = gRandom->Uniform(1,180);
            TH1F* th = ths_npe[binx-1][biny-1];
            npe_from_single = th->GetRandom();
        } else if (binx>1 and (biny<1 or biny>180)) {
            // std::cerr << "npe maybe lost: " << binx << "/" << biny << std::endl;
            // FIXME how to handle such situation.
            // biny = gRandom->Uniform(1,100);
            if (biny>180) { biny = 180; }
            else if (biny<1){ biny = 1; }

            TH1F* th = ths_npe[binx-1][biny-1];
            npe_from_single = th->GetRandom();
        } else {
            std::cerr << "npe lost: " << binx << "/" << biny << std::endl;
        }

        return npe_from_single;
    }

    TString m_filename_npe;
    TProfile2D* m_prof_npe;
    TProfile2D* m_prof2_npe;

    TString m_filename_npe_single;
    TH1F* ths_npe[100][180];
    TAxis* bins_r3;
    TAxis* bins_theta;

    bool m_lazy_loading;
};

}

#endif
