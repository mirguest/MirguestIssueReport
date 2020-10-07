
#ifndef PMTinTube_PRIMARYGENERATORACTION_hh
#define PMTinTube_PRIMARYGENERATORACTION_hh 1

#include "G4VUserPrimaryGeneratorAction.hh"

class G4ParticleGun;
class G4Event;

class PMTinTube_PrimaryGeneratorAction: public G4VUserPrimaryGeneratorAction
{
    public:
        PMTinTube_PrimaryGeneratorAction();
        ~PMTinTube_PrimaryGeneratorAction();

        void GeneratePrimaries(G4Event* anEvent);

    private:
        G4ParticleGun* particleGun;

};

#endif
