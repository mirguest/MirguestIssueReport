
#ifndef Hello_Detector_Construction
#define Hello_Detector_Construction

class G4LogicalVolume;
class G4VPhysicalVolume;
class G4Material;

#include "G4VUserDetectorConstruction.hh"

class Hello_DetectorConstruction : public G4VUserDetectorConstruction
{
    public:
        Hello_DetectorConstruction();
        ~Hello_DetectorConstruction();

        G4VPhysicalVolume* Construct();

        void makeVariables();
        void makeMaterial();
        G4LogicalVolume*   makeWorldLogical();
        G4VPhysicalVolume* makeWorldPhysical();
        G4LogicalVolume*   makePMTLogical();
        G4VPhysicalVolume* makePMTPhysical();

    private:
        // Volume
        G4LogicalVolume* experimentalHall_log;
        G4VPhysicalVolume* experimentalHall_phys;

        G4LogicalVolume* pmttube_log;
        G4VPhysicalVolume* pmttube_phys;

        // Material
        G4Material* Vacuum;
        G4Material* Al;

        // Variables;
        G4double expHall_x; 
        G4double expHall_y;
        G4double expHall_z;

        G4double pmttube_r;
        G4double pmttube_h;

        G4double ball_r;

        G4double gap;
};       

#endif
