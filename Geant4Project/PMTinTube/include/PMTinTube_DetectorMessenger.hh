#ifndef PMTinTube_DetectorMessenger_hh
#define PMTinTube_DetectorMessenger_hh

#include "globals.hh"
#include "G4UImessenger.hh"

class PMTinTube_DetectorConstruction;
class G4UIdirectory;
class G4UIcmdWithoutParameter;
class G4UIcmdWithADoubleAndUnit;


class PMTinTube_DetectorMessenger: public G4UImessenger
{

public:
    PMTinTube_DetectorMessenger(PMTinTube_DetectorConstruction*);
    ~PMTinTube_DetectorMessenger();

    void SetNewValue(G4UIcommand*, G4String);

private:
    PMTinTube_DetectorConstruction* m_det;

    G4UIdirectory* m_ui_root;
    G4UIdirectory* m_ui_root_det;
    G4UIdirectory* m_ui_root_det_opttrd;

    // /lintao/det/opttrd/
    G4UIcmdWithoutParameter* m_opttrd_on;
    G4UIcmdWithoutParameter* m_opttrd_off;
    G4UIcmdWithADoubleAndUnit* m_opttrd_height;


};

#endif
