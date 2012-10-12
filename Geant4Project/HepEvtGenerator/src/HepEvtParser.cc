#include "HepEvtParser.hh"

#include "globals.hh"

#include <string>
#include <sstream>

namespace Generator {
  namespace Utils {

EasyHepEvtParser::EasyHepEvtParser( std::istream& in_f )
:m_hepevt_src(in_f), m_verbosity(4)
{
}

ParticleInfoContainer
EasyHepEvtParser::next() 
{
  ParticleInfoContainer new_pic;
  if ( checkOK( m_hepevt_src ) ) {
    G4int number_of_particles = getNumberOfParticles();
    if (m_verbosity > 3) {
      G4cout << "number_of_particles: " 
             << number_of_particles << G4endl;
    }

    for (G4int i = 0; i < number_of_particles; ++i ) {
      // Parse Per line.
    }

  }

  return new_pic;

}

G4int 
EasyHepEvtParser::getNumberOfParticles()
{
  G4int total = 0;
  std::string tmp_line;

  while ( checkOK(m_hepevt_src) ) {
    // Get the line from input stream.
    std::getline(m_hepevt_src, tmp_line);
    if (m_verbosity > 3) {
      G4cout << "LINE(Before): " << tmp_line << G4endl;
    }

    if ( tmp_line.size() ==0 ) {
      continue;
    }
    if (m_verbosity > 3) {
      G4cout << "LINE(After): " << tmp_line << G4endl;
    }
    std::stringstream ss;
    ss << tmp_line;
    ss >> total;

    if (ss.fail()) {
      continue;
    }

    if (m_verbosity > 3) {
      G4cout << total << G4endl;
    }
    return total;


  }

  return total;
}

G4bool
EasyHepEvtParser::checkOK( std::istream& is )
{
  return (is.good());
}


  }

}
