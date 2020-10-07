
#ifndef Hello_STEPPING_ACTION_H
#define Hello_STEPPING_ACTION_H 1

#include "G4UserSteppingAction.hh"

class Hello_SteppingAction: public G4UserSteppingAction
{
    public:
        Hello_SteppingAction();
        ~Hello_SteppingAction();
    public:
        void UserSteppingAction(const G4Step*);
};

#endif

