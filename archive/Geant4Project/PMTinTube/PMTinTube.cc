#include "G4RunManager.hh"
#include "G4UImanager.hh"

#ifdef G4VIS_USE
#include "G4VisExecutive.hh"
#endif

#ifdef G4UI_USE
#include "G4UIExecutive.hh"
#endif

// Project name: PMTinTube
#include "PMTinTube_DetectorConstruction.hh"
#include "PMTinTube_PhysicsList.hh"
#include "PMTinTube_PrimaryGeneratorAction.hh"

#include "PMTinTube_RunAction.hh"
#include "PMTinTube_EventAction.hh"
#include "PMTinTube_SteppingAction.hh"

int main(int argc, char** argv) {
    G4RunManager* runManager = new G4RunManager;

    // Detector 
    G4VUserDetectorConstruction* detector = new PMTinTube_DetectorConstruction;
    runManager -> SetUserInitialization(detector);
    // Physics List 
    G4VUserPhysicsList* physics = new PMTinTube_PhysicsList;
    runManager -> SetUserInitialization(physics);
    // Particle Generation 
    G4VUserPrimaryGeneratorAction* gen_action = new PMTinTube_PrimaryGeneratorAction;
    runManager -> SetUserAction(gen_action);

    // Run Action 
    G4UserRunAction* run_action = new PMTinTube_RunAction;
    runManager -> SetUserAction(run_action);
    //
    // Event Action 
    G4UserEventAction* event_action = new PMTinTube_EventAction;
    runManager -> SetUserAction(event_action);
    // Stepping action
    G4UserSteppingAction* stepping_action = new PMTinTube_SteppingAction;
    runManager -> SetUserAction(stepping_action);

    
    // Initialize G4 Kernel
    runManager -> Initialize();


#ifdef G4VIS_USE
    G4VisManager* visManager = new G4VisExecutive;
    visManager->Initialize();
#endif

    // Test -- lintao
    // Try to remove OptTrd
    //G4cout << "Try to Remove Logical OpticalTrd" << G4endl;
    //((PMTinTube_DetectorConstruction*)detector) -> RemoveLogicalOpticalTrd();
    //G4cout << "Try to Add Logical OpticalTrd" << G4endl;
    //((PMTinTube_DetectorConstruction*)detector) -> AddLogicalOpticalTrd();
    //G4cout << "Try to Modify Logical OpticalTrd" << G4endl;
    //((PMTinTube_DetectorConstruction*)detector) -> ModifyHeightLogicalOpticalTrd(55*cm);

    // Get the pointer to the User Interface manager
    //
    G4UImanager * UImanager = G4UImanager::GetUIpointer();

    if (argc!=1)   // batch mode  
    {
      G4String command = "/control/execute ";
      G4String fileName = argv[1];
      UImanager->ApplyCommand(command+fileName);
    }
    else           // interactive mode : define UI session
    {
#ifdef G4UI_USE
      G4UIExecutive * ui = new G4UIExecutive(argc,argv);
#ifdef G4VIS_USE
      UImanager->ApplyCommand("/control/execute vis.mac");
#endif
      ui->SessionStart();
      delete ui;
#endif

#ifdef G4VIS_USE
      delete visManager;
#endif
    }


    delete runManager;
    return 0;
}
