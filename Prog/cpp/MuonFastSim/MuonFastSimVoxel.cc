#include "MuonFastSimVoxel.hh"

#include "SniperKernel/SniperPtr.h"
#include "SniperKernel/ToolFactory.h"
#include "SniperKernel/SniperLog.h"
#include "SniperKernel/SniperException.h"
#include "RootWriter/RootWriter.h"

#include "G4Run.hh"
#include "G4Event.hh"
#include "G4Track.hh"
#include "G4Step.hh"

// force load the dict for vector<float>
#include "TROOT.h"

#include "DetSimAlg/DetSimAlg.h"
#include "PMTSDMgr.hh"

#include "G4LossTableManager.hh"
#include "G4MaterialCutsCouple.hh"
#include "G4Gamma.hh"
#include "G4Electron.hh"

DECLARE_TOOL(MuonFastSimVoxel);

MuonFastSimVoxel::MuonFastSimVoxel(const std::string& name)
    : ToolBase(name)
{

    m_helper_geom = 0;
    m_helper_hittime = 0;
    m_helper_npe = 0;

    geom_file = "geom-geom-20pmt.root";
    npe_loader_file = "npehist3d_single.root"; 
    hittime_mean_file = "hist3d.root";
    hittime_single_file = "dist_tres_single.root";

    m_merge_flag = false;
    m_time_window = 1;
    m_pmthitmerger = 0;

    m_fill_tuple = false;
    m_evt_tree = 0;

    declProp("GeomFile", geom_file);
    declProp("NPEFile", npe_loader_file);
    declProp("HitTimeMean", hittime_mean_file);
    declProp("HitTimeRes", hittime_single_file);

    declProp("MergeFlag", m_merge_flag);
    declProp("MergeTimeWindow", m_time_window);

    declProp("EnableNtuple", m_fill_tuple);

    declProp("EnableQuenching", m_quenching=true);
    declProp("QuenchingFactor", m_quenching_scale=0.93);
    declProp("BirksConst1", m_birksConst1 = 6.5e-3*(g/cm2/MeV));
    declProp("BirksConst2", m_birksConst2 = 1.5e-6*(g/cm2/MeV)*(g/cm2/MeV));

    // if lazy loading is true, the histograms will not load in initialization.
    declProp("LazyLoading", m_lazy_loading=false);

    // enable/disable nPE sampling
    declProp("SampleNPE", m_flag_npe=true);
    // enable/disable hit time sampling
    declProp("SampleTime", m_flag_time=true);
    // enable/disable save hits
    declProp("SaveHits", m_flag_savehits=true);
}

MuonFastSimVoxel::~MuonFastSimVoxel() 
{

}

void
MuonFastSimVoxel::BeginOfRunAction(const G4Run* aRun) {
    // load the magic distributions
    if (!m_helper_geom) {
        LogInfo << "Load Geometry File for Voxel Method: "
                << geom_file << std::endl;
        m_helper_geom = new VoxelMethodHelper::Geom();
        m_helper_geom->m_geom_file = geom_file;
        m_helper_geom->load();
        assert(m_helper_geom->PMT_pos.size());
    }
    if (!m_helper_hittime) {
        LogInfo << "Load Hit Time File for Voxel Method: "
                << hittime_mean_file << " / " 
                << hittime_single_file << std::endl;
        m_helper_hittime = new VoxelMethodHelper::HitTimeLoader();
        m_helper_hittime->m_single_filename = hittime_single_file;
        m_helper_hittime->m_lazy_loading=m_lazy_loading;
        m_helper_hittime->load();
        assert(m_helper_hittime->f_single);
    }
    if (!m_helper_npe) {
        LogInfo << "Load NPE File for Voxel Method: "
                << npe_loader_file << std::endl;
        m_helper_npe = new VoxelMethodHelper::NPELoader();
        m_helper_npe->m_filename_npe = npe_loader_file;
        m_helper_npe->m_filename_npe_single = npe_loader_file;
        m_helper_npe->m_lazy_loading=m_lazy_loading;
        m_helper_npe->load();
    }

    if (m_fill_tuple) {
        SniperPtr<RootWriter> svc("RootWriter");
        if (svc.invalid()) {
            LogError << "Can't Locate RootWriter. If you want to use it, please "
                     << "enalbe it in your job option file."
                     << std::endl;
            return;
        }
        gROOT->ProcessLine("#include <vector>");

        m_evt_tree = svc->bookTree("SIMEVT/voxelevt", "evt");
        m_evt_tree->Branch("evtID", &m_evtid, "evtID/I");
        m_evt_tree->Branch("pdgid", &m_pdgid);
        m_evt_tree->Branch("edep", &m_edep);
        m_evt_tree->Branch("Qedep", &m_Qedep);
        m_evt_tree->Branch("steplength", &m_steplength);

    }

    if (!m_pmthitmerger) {
        // get the merger from other tool
        SniperPtr<DetSimAlg> detsimalg(getScope(), "DetSimAlg");
        if (detsimalg.invalid()) {
            std::cout << "Can't Load DetSimAlg" << std::endl;
            assert(0);
        }

        ToolBase* t = 0;
        // find the tool first
        // create the tool if not exist
        std::string name = "PMTSDMgr";
        t = detsimalg->findTool(name);
        if (not t) {
            LogError << "Can't find tool " << name << std::endl;
            throw SniperException("Make sure you have load the PMTSDMgr.");
        }
        PMTSDMgr* pmtsd = dynamic_cast<PMTSDMgr*>(t);
        if (not pmtsd) {
            LogError << "Can't cast to " << name << std::endl;
            throw SniperException("Make sure PMTSDMgr is OK.");
        }
        m_pmthitmerger = pmtsd->getPMTMerger();
        // check the configure
        if (m_merge_flag and (not m_pmthitmerger->getMergeFlag())) {
            LogInfo << "change PMTHitMerger flag to: " << m_merge_flag << std::endl;
            m_pmthitmerger->setMergeFlag(m_merge_flag);
        }
        if (m_pmthitmerger->getMergeFlag() and (m_time_window!=m_pmthitmerger->getTimeWindow())) {
            LogInfo << "change PMTHitMerger merge time window to: " << m_time_window << std::endl;
            m_pmthitmerger->setTimeWindow(m_time_window);
        }
    }
}

void
MuonFastSimVoxel::EndOfRunAction(const G4Run* aRun) {

}

void
MuonFastSimVoxel::BeginOfEventAction(const G4Event* evt) {
    // get the hit collection
    // NOTE: because in PMT SD v2, every event will create a new hit collection,
    //       so we need to reset the pointer in end of event action.


    // clear ntuple
    if (m_fill_tuple and m_evt_tree) {
        m_evtid = evt->GetEventID();
        m_pdgid.clear();
        m_edep.clear();
        m_Qedep.clear();
        m_steplength.clear();
    }
}

void
MuonFastSimVoxel::EndOfEventAction(const G4Event* evt) {
    if (m_fill_tuple and m_evt_tree) {
        m_evt_tree->Fill();
    }
}

void
MuonFastSimVoxel::UserSteppingAction(const G4Step* step) {
    G4Track* track = step->GetTrack();
    G4double edep = step->GetTotalEnergyDeposit();
    G4double steplength = step->GetStepLength();
    bool needToSim = false;
    if (edep > 0 and track->GetDefinition()->GetParticleName()!= "opticalphoton"
                 and track->GetMaterial()->GetName() == "LS") {
        needToSim = true;
    }
    if (not needToSim) {
        return;
    }
    // fill the ntuple
    if (m_fill_tuple and m_evt_tree) {
        m_pdgid.push_back(track->GetDefinition()->GetPDGEncoding());
        m_edep.push_back(edep);
        m_steplength.push_back(steplength);
    }
    // TODO MAGIC HERE
    // Need to apply the non-linearity correction
    if (m_quenching) {
        edep = quenching(step);
    }
    if (m_fill_tuple and m_evt_tree) {
        m_Qedep.push_back(edep);
    }
    // scale the Qedep back to edep.
    // In the input distribution, we assume 1MeV (edep) gamma or electron -> nPE
    // However, in the simulation, the actual Qedep is 0.93 (or 0.97) MeV.
    edep /= m_quenching_scale; // For 1MeV gamma, the Qedep is 0.93MeV
                               // For 1MeV electron, the Qedep is 0.97MeV
    int intPart = static_cast<int>(edep);
    double fractionPart = edep - intPart;
    // TODO: the position can be (pre+post)/2
    G4ThreeVector pos = step -> GetPreStepPoint() -> GetPosition();
    double start_time = step -> GetPreStepPoint() -> GetGlobalTime();


    // r3 and cos(theta)
    // TAxis *xaxis = m_helper_hittime->prof_mean->GetXaxis();
    // TAxis *yaxis = m_helper_hittime->prof_mean->GetYaxis();

    TVector3 pos_src(pos.x(), pos.y(), pos.z());
    Double_t r = pos_src.Mag()/1e3; // mm -> m
    // Double_t r3 = TMath::Power(r, 3);
    // Int_t binx = xaxis->FindBin(r3);
    // loop 
    for (int i = 0; i < 17746; ++i) {
        const TVector3& pos_pmt = m_helper_geom->PMT_pos[i];
        float theta = pos_pmt.Angle(pos_src);
        // float costheta = TMath::Cos(theta);

        // Int_t biny = yaxis->FindBin(costheta);

        // std::cout << "bin number: " << binx << "/" << biny << std::endl;
        // int part
        for (int j = 0; j < intPart; ++j) {
            generate_hits(r, theta, 1, i, start_time);
        }
        // fraction part
        generate_hits(r, theta, fractionPart, i, start_time);
    }
    

}

bool
// MuonFastSimVoxel::generate_hits(int binx, int biny, double ratio, int pmtid, double start_time) 
MuonFastSimVoxel::generate_hits(float r, float theta, double ratio, int pmtid, double start_time) 
{
    // if don't sample npe, just return
    if (!m_flag_npe) {
        return true;
    }

    Int_t npe_from_single = m_helper_npe->get_npe(r, theta);
    if (npe_from_single>0) {
        for (int hitj = 0; hitj < npe_from_single; ++hitj) {
            // skip the photon according to the energy deposit
            if (ratio<1 and gRandom->Uniform()>ratio) { 
                continue; 
            }
            Double_t hittime = start_time;
            if (m_flag_time) {
                hittime += m_helper_hittime->get_hittime(r, theta, 0);
            }
            // generated hit
            if (m_flag_savehits) {
                save_hits(pmtid, hittime);
            }
        }
    }
    return true;
}

bool
MuonFastSimVoxel::save_hits(int pmtid, double hittime) {

    if (m_pmthitmerger->getMergeFlag()) {
        // == if merged, just return true. That means just update the hit
        // NOTE: only the time and count will be update here, the others 
        //       will not filled.
        bool ok = m_pmthitmerger->doMerge(pmtid, hittime);
        if (ok) {
            return true;
        }
    }
    if (m_pmthitmerger->hasNormalHitType()) {
        dywHit_PMT* hit_photon = new dywHit_PMT();
        hit_photon->SetPMTID(pmtid);
        hit_photon->SetTime(hittime);
        hit_photon->SetCount(1); // FIXME
        // == insert
        m_pmthitmerger->saveHit(hit_photon);
    } else if (m_pmthitmerger->hasMuonHitType()) {
        dywHit_PMT_muon* hit_photon = new dywHit_PMT_muon();
        hit_photon->SetPMTID(pmtid);
        hit_photon->SetTime(hittime);
        hit_photon->SetCount(1); // FIXME
        // == insert
        m_pmthitmerger->saveHit(hit_photon);
    }
    return true;
}

double 
MuonFastSimVoxel::quenching(const G4Step* step) {
    double QuenchedTotalEnergyDeposit = 0.0;

    G4Track* track = step->GetTrack();
    const G4DynamicParticle* aParticle = track->GetDynamicParticle();
    const G4Material* material = track->GetMaterial();

    G4double dE = step->GetTotalEnergyDeposit();
    G4double dx = step->GetStepLength();
    G4double dE_dx = dE/dx;

    if(track->GetDefinition() == G4Gamma::Gamma() && dE > 0)
    { 
      G4LossTableManager* manager = G4LossTableManager::Instance();
      dE_dx = dE/manager->GetRange(G4Electron::Electron(), dE, track->GetMaterialCutsCouple());
      //G4cout<<"gamma dE_dx = "<<dE_dx/(MeV/mm)<<"MeV/mm"<<G4endl;
    }

    G4double delta = dE_dx/material->GetDensity();//get scintillator density 
    //G4double birk1 = 0.0125*g/cm2/MeV;
    G4double birk1 = m_birksConst1;
    if(abs(aParticle->GetCharge())>1.5)//for particle charge greater than 1.
        birk1 = 0.57*birk1;
    
    G4double birk2 = 0;
    //birk2 = (0.0031*g/MeV/cm2)*(0.0031*g/MeV/cm2);
    birk2 = m_birksConst2;
    
    QuenchedTotalEnergyDeposit 
        = dE/(1+birk1*delta+birk2*delta*delta);


    return QuenchedTotalEnergyDeposit;
}
