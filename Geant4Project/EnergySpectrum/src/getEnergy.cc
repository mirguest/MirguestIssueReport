
#include "getEnergy.hh"

namespace Generator {
  namespace Utils {

G4double
getEnergyFromParticleInfo( ParticleInfo& pi) 
{
  G4double energy = 0.0;

  return energy;
}

G4double
getEnergyFromContainer( ParticleInfoContainer& pic ) 
{
  G4double total_energy = 0.0;
  ParticleInfoContainer::iterator pic_iter = pic.begin();

  for( ; pic_iter != pic.end(); ++pic_iter) {
    total_energy += getEnergyFromParticleInfo((*pic_iter));

  }
  return total_energy;


}

  }

}
