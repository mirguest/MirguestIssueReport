
#include "PMTinTube_PhysicsList.hh" 

#include "globals.hh" 
#include "G4ProcessManager.hh"
#include "G4ParticleTypes.hh"

PMTinTube_PhysicsList::PMTinTube_PhysicsList() 
    : G4VUserPhysicsList()
{
    defaultCutValue = 1.0 *cm;
}

PMTinTube_PhysicsList::~PMTinTube_PhysicsList() 
{

}

void PMTinTube_PhysicsList::ConstructParticle()
{

}

void PMTinTube_PhysicsList::ConstructProcess()
{

}

void PMTinTube_PhysicsList::SetCuts()
{

}
