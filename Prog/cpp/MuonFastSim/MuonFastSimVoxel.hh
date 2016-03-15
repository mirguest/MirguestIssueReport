#ifndef MuonFastSimVoxel_hh
#define MuonFastSimVoxel_hh

/*
 * Description:
 *     This class is used for the Voxel Method of Muon Fast Simulation.
 *     The distribution of hit time and nPE are generated from
 *     * anajuno/muonsim/share/dispatch.C
 *     * anajuno/muonsim/share/dispatch2.C
 *
 *     We only consider the vertex \vec{r} and position of PMT \vec{PMT}:
 *     * r**3
 *     * theta, <\vec{r}, \vec{PMT}>
 *
 *     A validation code can also be found in:
 *     * anajuno/muonsim/share/validateNPE.C
 *
 *     Three necessary helpers:
 *     1. Geometry Helper, supply the position of PMT
 *     2. Hit Time Helper, generate TOF (time of flight)
 *     3. NPE Helper, generate NPE.
 *
 *     The generated hits are put into hit collection. 
 * Author: Tao Lin <lintao@ihep.ac.cn>
 */

#include "SniperKernel/ToolBase.h"
#include "DetSimAlg/IAnalysisElement.h"

// retrieve the hit collection
#include "dywHit_PMT.hh"
#include "G4HCofThisEvent.hh"
#include "G4VHitsCollection.hh"
#include "G4SDManager.hh"
#include "MuonFastSimVoxelHelper.hh"
#include "PMTHitMerger.hh"

#include <map>
#include <vector>

class G4Event;

class MuonFastSimVoxel: public IAnalysisElement,
                        public ToolBase {
public:
    MuonFastSimVoxel(const std::string& name);
    ~MuonFastSimVoxel();

    // Run Action
    virtual void BeginOfRunAction(const G4Run*);
    virtual void EndOfRunAction(const G4Run*);
    // Event Action
    virtual void BeginOfEventAction(const G4Event*);
    virtual void EndOfEventAction(const G4Event*);
    // Stepping Action
    virtual void UserSteppingAction(const G4Step*); 

private:
    // bool generate_hits(int binx, int biny, double fractionPart, int pmtid, double start_time);
    bool generate_hits(float r, float theta, double fractionPart, int pmtid, double start_time);
    bool save_hits(int pmtid, double hittime);

    double quenching(const G4Step* step);

private:
    // helper classes and variables
    VoxelMethodHelper::Geom* m_helper_geom;
    VoxelMethodHelper::HitTimeLoader* m_helper_hittime;
    VoxelMethodHelper::NPELoader* m_helper_npe;

    // input
    std::string geom_file;
    std::string npe_loader_file;
    std::string hittime_mean_file;
    std::string hittime_single_file;

    // merger
    // copy from dywSD_PMT_v2
    // keep the flag and time window exist
    bool m_merge_flag;
    double m_time_window;
    PMTHitMerger* m_pmthitmerger;

    // debug
    bool m_fill_tuple;
    TTree* m_evt_tree;
    int m_evtid;
    std::vector<int> m_pdgid;
    std::vector<float> m_edep;
    std::vector<float> m_Qedep;
    std::vector<float> m_steplength;

    bool m_quenching;
    double m_quenching_scale;
    double m_birksConst1;
    double m_birksConst2;

    // lazy loading
    bool m_lazy_loading;

    bool m_flag_npe;
    bool m_flag_time;
    bool m_flag_savehits;

};

#endif
