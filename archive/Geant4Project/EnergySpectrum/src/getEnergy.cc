
#include "getEnergy.hh"

#include <globals.hh>
#include <cmath>
using namespace std;

namespace Generator {
  namespace Utils {

G4double
getEnergyFromParticleInfo( ParticleInfo& pinfo) 
{
  // The Units of px, py, pz and mass are GeV.
  G4double energy = sqrt(
                        pow(pinfo.px , 2) +
                        pow(pinfo.py , 2) +
                        pow(pinfo.pz , 2) +
                        pow(pinfo.mass , 2) 
                        );

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
