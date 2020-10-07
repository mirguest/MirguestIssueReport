
#ifndef Hello_RUN_ACTION_H
#define Hello_RUN_ACTION_H 1

#include "G4UserRunAction.hh"
#include "globals.hh"

class G4Run;

class Hello_RunAction: public G4UserRunAction
{
    public:
        Hello_RunAction();
        ~Hello_RunAction();

    public:
        void BeginOfRunAction(const G4Run*);
        void EndOfRunAction(const G4Run*);
};

#endif

