#ifndef PVPathTransform_hh
#define PVPathTransform_hh

#include <vector>
#include <string>

#include "G4ThreeVector.hh"
#include "G4AffineTransform.hh"

class G4VPhysicalVolume;

class PVPathTransform {

public:

    std::vector<std::string> parsePath(std::string);
    std::vector<G4VPhysicalVolume*> convertPathToPV(const std::vector<std::string>&);

    G4AffineTransform getGTL(const std::vector<G4VPhysicalVolume*>&);

};

#endif
