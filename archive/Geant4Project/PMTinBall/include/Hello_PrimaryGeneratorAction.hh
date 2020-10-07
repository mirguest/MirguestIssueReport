
#ifndef Hello_PRIMARYGENERATORACTION_hh
#define Hello_PRIMARYGENERATORACTION_hh 1

#include "G4VUserPrimaryGeneratorAction.hh"

class G4ParticleGun;
class G4Event;

class Hello_PrimaryGeneratorAction: public G4VUserPrimaryGeneratorAction
{
    public:
        Hello_PrimaryGeneratorAction();
        ~Hello_PrimaryGeneratorAction();

        void GeneratePrimaries(G4Event* anEvent);

    private:
        G4ParticleGun* particleGun;

};

#endif
