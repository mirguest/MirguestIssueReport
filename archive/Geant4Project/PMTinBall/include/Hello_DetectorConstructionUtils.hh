#ifndef Hello_DetectorConstruction_hh
#define Hello_DetectorConstruction_hh

#include "globals.hh"

namespace Utils {

namespace Ball {

G4int GetMaxiumNumInCircle(G4double r_circle, 
                           G4double r_pmt, 
                           G4double gap);

}

}

#endif
