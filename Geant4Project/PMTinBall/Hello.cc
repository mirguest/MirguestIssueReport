#include "G4RunManager.hh"
#include "G4UImanager.hh"

#ifdef G4VIS_USE
#include "G4VisExecutive.hh"
#endif

#ifdef G4UI_USE
#include "G4UIExecutive.hh"
#endif

// Project name: Hello
#include "Hello_DetectorConstruction.hh"
#include "Hello_PhysicsList.hh"
#include "Hello_PrimaryGeneratorAction.hh"

#include "Hello_RunAction.hh"
#include "Hello_EventAction.hh"
#include "Hello_SteppingAction.hh"

#include "PVPathTransform.hh"

int main(int argc, char** argv) {
    G4RunManager* runManager = new G4RunManager;

    // Detector 
    G4VUserDetectorConstruction* detector = new Hello_DetectorConstruction;
    runManager -> SetUserInitialization(detector);
    // Physics List 
    G4VUserPhysicsList* physics = new Hello_PhysicsList;
    runManager -> SetUserInitialization(physics);
    // Particle Generation 
    G4VUserPrimaryGeneratorAction* gen_action = new Hello_PrimaryGeneratorAction;
    runManager -> SetUserAction(gen_action);

    // Run Action 
    G4UserRunAction* run_action = new Hello_RunAction;
    runManager -> SetUserAction(run_action);
    //
    // Event Action 
    G4UserEventAction* event_action = new Hello_EventAction;
    runManager -> SetUserAction(event_action);
    // Stepping action
    G4UserSteppingAction* stepping_action = new Hello_SteppingAction;
    runManager -> SetUserAction(stepping_action);

    
    // Initialize G4 Kernel
    runManager -> Initialize();

    // Test 
    PVPathTransform pvpt;
    pvpt.quick_test();

#ifdef G4VIS_USE
    G4VisManager* visManager = new G4VisExecutive;
    visManager->Initialize();
#endif

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
