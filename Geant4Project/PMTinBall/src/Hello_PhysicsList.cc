
#include "Hello_PhysicsList.hh" 

#include "globals.hh" 
#include "G4ProcessManager.hh"
#include "G4ParticleTypes.hh"

Hello_PhysicsList::Hello_PhysicsList() 
    : G4VUserPhysicsList()
{
    defaultCutValue = 1.0 *cm;
}

Hello_PhysicsList::~Hello_PhysicsList() 
{

}

void Hello_PhysicsList::ConstructParticle()
{

}

void Hello_PhysicsList::ConstructProcess()
{

}

void Hello_PhysicsList::SetCuts()
{

}
