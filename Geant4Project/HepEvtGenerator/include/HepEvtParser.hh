#ifndef HepEvtParser_hh
#define HepEvtParser_hh

#include <istream>
#include <fstream>
#include <iostream>
#include "ParticleDescription.hh"

namespace Generator {
  namespace Utils {

class EasyHepEvtParser {
public:
  EasyHepEvtParser( std::istream& );

  ParticleInfoContainer next();

private:
  G4int getNumberOfParticles();

private:
  std::istream& m_hepevt_src;

};

  }

}

#endif
