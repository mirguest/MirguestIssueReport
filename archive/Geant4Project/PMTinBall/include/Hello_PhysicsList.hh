
#ifndef Hello_PHYSICSLIST_HH
#define Hello_PHYSICSLIST_HH 1

#include "G4VUserPhysicsList.hh"
#include "globals.hh"

class Hello_PhysicsList: public G4VUserPhysicsList
{
    public:
        Hello_PhysicsList();
        ~Hello_PhysicsList();
    protected:
        void ConstructParticle();
        void ConstructProcess();
        void SetCuts();
};

#endif
