
#ifndef PMTinTube_RUN_ACTION_H
#define PMTinTube_RUN_ACTION_H 1

#include "G4UserRunAction.hh"
#include "globals.hh"

class G4Run;

class PMTinTube_RunAction: public G4UserRunAction
{
    public:
        PMTinTube_RunAction();
        ~PMTinTube_RunAction();

    public:
        void BeginOfRunAction(const G4Run*);
        void EndOfRunAction(const G4Run*);
};

#endif

