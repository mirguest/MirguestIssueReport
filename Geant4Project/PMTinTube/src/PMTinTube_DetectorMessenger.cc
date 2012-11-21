
#include "PMTinTube_DetectorMessenger.hh"
#include "PMTinTube_DetectorConstruction.hh"

#include "G4UImanager.hh"
#include "G4UIdirectory.hh"
#include "G4UIcmdWithoutParameter.hh"
#include "G4UIcmdWithADoubleAndUnit.hh"


PMTinTube_DetectorMessenger::PMTinTube_DetectorMessenger(
        PMTinTube_DetectorConstruction* det)
        : m_det(det)
{
    m_ui_root = new G4UIdirectory("/lintao/");
    m_ui_root -> SetGuidance("Test of Lintao");

    m_ui_root_det = new G4UIdirectory("/lintao/det/");
    m_ui_root_det -> SetGuidance("Detector Control");

    m_ui_root_det_opttrd = new G4UIdirectory("/lintao/det/opttrd/");
    m_ui_root_det -> SetGuidance("Detector Control: Optical Trd Control");

    /* commands in /lintao/det/opttrd */

    m_opttrd_on = new G4UIcmdWithoutParameter("/lintao/det/opttrd/on", this);
    m_opttrd_on -> SetGuidance("Turn on the Optical Trd");
    m_opttrd_on -> AvailableForStates(G4State_PreInit, G4State_Idle);
    m_opttrd_off = new G4UIcmdWithoutParameter("/lintao/det/opttrd/off", this);
    m_opttrd_off -> SetGuidance("Turn off the Optical Trd");
    m_opttrd_off -> AvailableForStates(G4State_PreInit, G4State_Idle);

    m_opttrd_height = new G4UIcmdWithADoubleAndUnit("/lintao/det/opttrd/setHeight", this);
    m_opttrd_height -> SetGuidance("Set Height of OptTrd");
    m_opttrd_height -> SetParameterName("Size", false);
    m_opttrd_height -> SetRange("Size>0.");
    m_opttrd_height -> SetUnitCategory("Length");
    m_opttrd_height -> AvailableForStates(G4State_Idle, G4State_Idle);


}

PMTinTube_DetectorMessenger::~PMTinTube_DetectorMessenger()
{
    delete m_ui_root;
    delete m_ui_root_det;
    delete m_ui_root_det_opttrd;

    delete m_opttrd_on;
    delete m_opttrd_off;
    delete m_opttrd_height;
}

void
PMTinTube_DetectorMessenger::SetNewValue(G4UIcommand* command, G4String newValue)
{
    if (command == m_opttrd_on) {
        m_det -> UIOptTrdOn();        
    } else if (command == m_opttrd_off) {
        m_det -> UIOptTrdOff();        
    }

    if (command == m_opttrd_height) {
        m_det -> UIOptTrdHeight(
                    m_opttrd_height->GetNewDoubleValue(newValue));
    }

    G4UImanager* UI = G4UImanager::GetUIpointer();
    UI -> ApplyCommand("/vis/viewer/refresh");
    G4cout << "LINTAO::MESSAGE:: Detector Messenger" << G4endl;
    G4cout << "TRY TO REFRESH VIEW" << G4endl;
}
