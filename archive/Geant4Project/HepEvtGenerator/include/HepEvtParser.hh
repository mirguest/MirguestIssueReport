#ifndef HepEvtParser_hh
#define HepEvtParser_hh

#include <istream>
#include <fstream>
#include <iostream>
#include <map>
#include "ParticleDescription.hh"
#include "globals.hh"

namespace Generator {
  namespace Utils {

class EasyHepEvtParser {
public:
  //EasyHepEvtParser( std::istream& );
  EasyHepEvtParser( std::string );

  void setVerbosity(G4int verbosity);
  ParticleInfoContainer next();

private:
  G4int getNumberOfParticles();
  ParticleInfo getParticleInfoPerLine();

  G4bool checkOK( std::istream& );

  G4int getPDGID(G4int);
private:
  //std::istream& m_hepevt_src;
  std::ifstream m_hepevt_src;

  G4int m_verbosity;

  // Need to reset per EVENT.
  G4double global_dtime;

  // For Map OLD PDG ID to NEW PDG ID
  //
  std::map< G4int, G4int > m_pdg_mapper;


};

  }

}

#endif
