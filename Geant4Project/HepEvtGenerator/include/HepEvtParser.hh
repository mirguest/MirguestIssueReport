#ifndef HepEvtParser_hh
#define HepEvtParser_hh

#include <istream>
#include <fstream>
#include <iostream>
#include "ParticleDescription.hh"
#include "globals.hh"

namespace Generator {
  namespace Utils {

class EasyHepEvtParser {
public:
  EasyHepEvtParser( std::istream& );

  void setVerbosity(G4int verbosity);
  ParticleInfoContainer next();

private:
  G4int getNumberOfParticles();
  ParticleInfo getParticleInfoPerLine();

  G4bool checkOK( std::istream& );

private:
  std::istream& m_hepevt_src;

  G4int m_verbosity;

};

  }

}

#endif
