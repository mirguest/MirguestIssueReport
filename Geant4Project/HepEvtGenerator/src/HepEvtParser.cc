#include "HepEvtParser.hh"

#include "globals.hh"

#include <string>
#include <sstream>
#include <cassert>

namespace Generator {
  namespace Utils {

EasyHepEvtParser::EasyHepEvtParser( std::istream& in_f )
:m_hepevt_src(in_f), m_verbosity(4)
{
}

void
EasyHepEvtParser::setVerbosity(G4int verbosity)
{
  m_verbosity = verbosity;
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
      new_pic . push_back(getParticleInfoPerLine());
    }

    // Assert the size is the same.
    assert ( new_pic.size() == number_of_particles );

  }

  return new_pic;

}

G4int 
EasyHepEvtParser::getNumberOfParticles()
{
  G4int total = 0;
  std::string tmp_tail;
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

    // Try to Judge, is there any string?
    ss >> tmp_tail;
    // If it fails, that mean, no more any character.
    // else, read again.
    if (!ss.fail()) {
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


ParticleInfo 
EasyHepEvtParser::getParticleInfoPerLine() 
{
  ParticleInfo tmp_pi;
  G4int status = 0;
  G4int id = 0;
  G4int daughter_begin, daughter_end;
  G4double px, py, pz;
  G4double mass = 0.0;
  G4double global_dtime = 0.0;
  G4double dtime = 0.0;
  std::string tmp_line;

  while ( checkOK(m_hepevt_src) ) {
    // Get the Line.
    std::getline(m_hepevt_src, tmp_line);

    std::stringstream ss;
    ss << tmp_line;

    // Parse Status
    ss >> status;
    if (ss.fail()) {
      continue;
    }
    if (m_verbosity > 3) {
      G4cout << "HEPEVT Status: " 
             << status << G4endl;
    }
    // Parse ID
    ss >> id;
    if (ss.fail()) {
      continue;
    }
    if (m_verbosity > 3) {
      G4cout << "HEPEVT ID: " 
             << id << G4endl;
    }
    // Parse Daughter
    ss >> daughter_begin >> daughter_end;
    if (ss.fail()) {
      continue;
    }
    if (m_verbosity > 3) {
      G4cout << "HEPEVT Daughter: " 
             << "From: " << daughter_begin << ", "
             << "To  : " << daughter_end
             << G4endl;
    }
    // Parse Px, Py, Pz
    ss >> px >> py >> pz;
    if (ss.fail()) {
      continue;
    }
    if (m_verbosity > 3) {
      G4cout << "HEPEVT P: " 
             << "( " 
             << px << ", "
             << py << ", "
             << pz << ") "
             << G4endl;
    }
    // Parse Mass
    ss >> mass;
    if (ss.fail()) {
      continue;
    }
    if (m_verbosity > 3) {
      G4cout << "HEPEVT Mass: " 
             << mass
             << G4endl;
    }

    tmp_pi . pid = id;
    tmp_pi . px = px * GeV;
    tmp_pi . py = py * GeV;
    tmp_pi . pz = pz * GeV;
    tmp_pi . mass = mass * GeV;

    // Then, It is Optional.
    // Parse Time
    ss >> dtime;
    if (ss.fail()) {
      // If fails, set it to ZERO.
      dtime = 0.0;
    }

    global_dtime += dtime;

    if (m_verbosity > 3) {
      G4cout << "HEPEVT Global DTime: " 
             << global_dtime
             << G4endl
             << "HEPEVT Local DTime: "
             << dtime
             << G4endl;
    }

    tmp_pi . dt = global_dtime;

    break;
  }

  return tmp_pi;

}

  }

}
