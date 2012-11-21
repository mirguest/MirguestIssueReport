#ifndef Hello_Event_Action_H
#define Hello_Event_Action_H 1

#include "G4UserEventAction.hh"

class G4Event;

class Hello_EventAction: public G4UserEventAction
{
    public:
        Hello_EventAction();
        ~Hello_EventAction();

    public:
        void BeginOfEventAction(const G4Event*);
        void EndOfEventAction(const G4Event*);
};

#endif

