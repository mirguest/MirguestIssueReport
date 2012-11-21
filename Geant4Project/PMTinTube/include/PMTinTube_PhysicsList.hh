
#ifndef PMTinTube_PHYSICSLIST_HH
#define PMTinTube_PHYSICSLIST_HH 1

#include "G4VUserPhysicsList.hh"
#include "globals.hh"

class PMTinTube_PhysicsList: public G4VUserPhysicsList
{
    public:
        PMTinTube_PhysicsList();
        ~PMTinTube_PhysicsList();
    protected:
        void ConstructParticle();
        void ConstructProcess();
        void SetCuts();
};

#endif
