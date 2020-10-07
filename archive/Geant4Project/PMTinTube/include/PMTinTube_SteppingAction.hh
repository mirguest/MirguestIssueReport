
#ifndef PMTinTube_STEPPING_ACTION_H
#define PMTinTube_STEPPING_ACTION_H 1

#include "G4UserSteppingAction.hh"

class PMTinTube_SteppingAction: public G4UserSteppingAction
{
    public:
        PMTinTube_SteppingAction();
        ~PMTinTube_SteppingAction();
    public:
        void UserSteppingAction(const G4Step*);
};

#endif

