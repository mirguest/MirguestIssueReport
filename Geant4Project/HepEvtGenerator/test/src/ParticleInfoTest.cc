#include "ParticleInfoTest.hh"

#include "ParticleDescription.hh"

namespace Test {

void
ParticleInfoTest::testParticleInfo()
{
  Generator::Utils::ParticleInfo gu_pi;
  gu_pi . pid = 22;
  gu_pi . px = 1.216710e-03 * GeV;
  gu_pi . py = 6.703129e-04 * GeV;
  gu_pi . pz = -4.525696e-04 * GeV;
}

}
