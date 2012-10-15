
#include "HepEvtParser.hh"
#include "getEnergy.hh"
#include "globals.hh"

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>

int main (int argc, char** argv) {

  if( argc == 1 ) {
    G4cout << "Usage: " << argv[0] << " HepEvtFile ..." << G4endl;
    exit(-1);
  }

  for (int i = 1; i < argc; ++i) {

    std::ifstream ifin(argv[i]);
    Generator::Utils::EasyHepEvtParser ehep(ifin);
    ehep.setVerbosity(0);
    Generator::Utils::ParticleInfoContainer pic_u;

    while ( (pic_u = ehep.next()).size() ) {
      G4cout << getEnergyFromContainer(pic_u) << G4endl;
    }

  }

}
