
#include "ParticleInfoTest.hh"
#include "HepEvtParserTest.hh"

int main (void) {

  Test::ParticleInfoTest pit;

  pit.testParticleInfo();

  Test::HepEvtParserTest hept;

  hept.testOpen();

}
