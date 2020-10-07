#ifndef PMTinTube_Event_Action_H
#define PMTinTube_Event_Action_H 1

#include "G4UserEventAction.hh"

class G4Event;

class PMTinTube_EventAction: public G4UserEventAction
{
    public:
        PMTinTube_EventAction();
        ~PMTinTube_EventAction();

    public:
        void BeginOfEventAction(const G4Event*);
        void EndOfEventAction(const G4Event*);
};

#endif

