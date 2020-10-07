#include "Hello_DetectorConstructionUtils.hh"

#include <cmath>

namespace Utils {
namespace Ball {

G4int GetMaxiumNumInCircle(G4double r_circle, 
                           G4double r_pmt, 
                           G4double gap)
{
  G4int N=0;
  G4double theta = 2 * atan(r_pmt / r_circle);
  G4double phi = 2* asin(gap / (2*sqrt(r_pmt*r_pmt + r_circle*r_circle)));
  N = int(2*pi / (theta + phi));
  return N;


}

}

}
