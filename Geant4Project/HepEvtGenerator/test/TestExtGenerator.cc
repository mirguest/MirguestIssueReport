
#include "ParticleInfoTest.hh"
#include "HepEvtParserTest.hh"

#include "globals.hh"

int main (void) {

  Test::ParticleInfoTest pit;

  pit.testParticleInfo();

  Test::HepEvtParserTest hept;

  hept.testOpen();

  G4cout << "################################" << G4endl;

  hept.testReadTime();

}
