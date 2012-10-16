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
  ehep_th.setVerbosity(0);
  Generator::Utils::ParticleInfoContainer pic_th;
  do {
  pic_th = ehep_th.next();
  G4cout << pic_th.size() << G4endl;
  } while (pic_th.size());

  std::ifstream ifin3("u_decas.asc");
  Generator::Utils::EasyHepEvtParser ehep_u(ifin3);
  ehep_u.setVerbosity(0);
  Generator::Utils::ParticleInfoContainer pic_u;
  do {
  pic_u = ehep_u.next();
  G4cout << pic_u.size() << G4endl;
  } while (pic_u.size());

}

void
HepEvtParserTest::testReadTime() {

  std::ifstream ifin("Data_of_HepEvtParserTest.txt");
  Generator::Utils::EasyHepEvtParser ehep2(ifin);
  Generator::Utils::ParticleInfoContainer pic = ehep2.next();

  std::ifstream ifin2("th_decays.asc");
  Generator::Utils::EasyHepEvtParser ehep_th(ifin2);
  Generator::Utils::ParticleInfoContainer pic_th;

  for (int i=0; i<10; ++i) {
    pic_th = ehep_th.next();
    G4cout << pic_th.size() << G4endl;
  }
}

}
