
#ifndef PMTinTube_Detector_Construction
#define PMTinTube_Detector_Construction

#include <vector>
using namespace std;

class G4LogicalVolume;
class G4VPhysicalVolume;

class G4Box;
class G4Tubs;
class G4Trd;
class G4Material;

class PMTinTube_DetectorMessenger;

#include "G4VUserDetectorConstruction.hh"
#include "G4ThreeVector.hh"

class PMTinTube_DetectorConstruction : public G4VUserDetectorConstruction
{
    public:
        PMTinTube_DetectorConstruction();
        ~PMTinTube_DetectorConstruction();

        G4VPhysicalVolume* Construct();

    public:
        void UIOptTrdOn();
        void UIOptTrdOff();
        void UIOptTrdHeight(G4double height);

    private:

        void RemoveLogicalOpticalTrd();
        void AddLogicalOpticalTrd();
        void ModifyHeightLogicalOpticalTrd(G4double height);

    private:
        void DefineMaterials();
        void DefineVariables();
        void CreateLogicalWorld();

        void CreateLogicalPMTTube();
        void CreateLogicalOpticalTrd();

        void CreateLogicalTrap();

    private:
        /* calculate */
        G4int GetMaxiumNinCircle(G4double r_tube,
                                    G4double r_pmt,
                                    G4double gap);
        G4int GetMaxiumNinHalfHeight(G4double h,
                                     G4double r,
                                     G4double gap);

        void RemovePMTPhysicalVolumeByCopyNo(G4int copyno);
        void AddPMTPhysicalVolumeByCopyNo(G4int copyno);

        void Helper_ModifyOptTrdHeight(G4LogicalVolume*);
        void Helper_ModifyOptTrdPosition(G4VPhysicalVolume*);



    private:
        // Messenger
        PMTinTube_DetectorMessenger* m_det_msg;
        G4bool m_opt_trd_on_off;

        // Detector Volumes
        // World
        G4ThreeVector world_size;
        G4Box* world_solid;
        G4LogicalVolume* world_logic;
        G4VPhysicalVolume* world_physi;
        // PMT Tube (Virtual)
        G4double pmttube_r;
        G4double pmttube_h;

        G4double pmt_place_r;
        G4double pmt_place_h;
        G4double pmt_place_gap;

        G4Tubs* pmttube_solid;
        G4LogicalVolume* pmttube_logic;
        vector<G4VPhysicalVolume*> pmttubes_physi;

        // Optical Trapezoid
        G4Trd* opttrd_solid;
        G4LogicalVolume* opttrd_logic;
        vector<G4VPhysicalVolume*> opttrds_physi;

        G4double opttrd_d;
        G4double opttrd_h;

        // Material
        G4Material* Vacuum;
        G4Material* Al;
};

#endif
