#include "HepEvtParser.hh"

#include "globals.hh"

namespace Generator {
  namespace Utils {

EasyHepEvtParser::EasyHepEvtParser( std::istream& in_f )
:m_hepevt_src(in_f)
{
}

ParticleInfoContainer
EasyHepEvtParser::next() 
{
  ParticleInfoContainer new_pic;
  if ( m_hepevt_src ) {
    G4int number_of_particles = getNumberOfParticles();
    //G4cout << number_of_particles << G4endl;

  }

  return new_pic;

}

G4int 
EasyHepEvtParser::getNumberOfParticles()
{
  G4int total = 0;

  return total;
}


  }

}
