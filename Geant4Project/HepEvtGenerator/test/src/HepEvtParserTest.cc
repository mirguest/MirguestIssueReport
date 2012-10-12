#include "HepEvtParserTest.hh"

#include "HepEvtParser.hh"

#include <iostream>

namespace Test {

void
HepEvtParserTest::testOpen() {
  Generator::Utils::EasyHepEvtParser ehep(std::cin);

  std::ifstream ifin("Data_of_HepEvtParserTest.txt");
  Generator::Utils::EasyHepEvtParser ehep2(ifin);

}

}
