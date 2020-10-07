#ifndef getEnergy_hh
#define getEnergy_hh


#include "globals.hh"
#include "ParticleDescription.hh"


namespace Generator {
  namespace Utils {

G4double getEnergyFromParticleInfo( ParticleInfo& );
G4double getEnergyFromContainer( ParticleInfoContainer& );

}

}

#endif
