#include "HepEvtParserTest.hh"

#include "HepEvtParser.hh"

#include <iostream>

#include "globals.hh"

namespace Test {

void
HepEvtParserTest::testOpen() {
  //Generator::Utils::EasyHepEvtParser ehep(std::cin);

  std::ifstream ifin("Data_of_HepEvtParserTest.txt");
  Generator::Utils::EasyHepEvtParser ehep2(ifin);
  Generator::Utils::ParticleInfoContainer pic = ehep2.next();

  G4cout << pic.size() << G4endl;

  std::ifstream ifin2("th_decays.asc");
  Generator::Utils::EasyHepEvtParser ehep_th(ifin2);
  Generator::Utils::ParticleInfoContainer pic_th;
  pic_th = ehep_th.next();
  G4cout << pic_th.size() << G4endl;

}

}
