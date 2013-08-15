
#include "PVPathTransform.hh"

#include <sstream>
#include <exception>
#include <stdexcept>

#include "G4VPhysicalVolume.hh"
#include "G4PhysicalVolumeStore.hh"

std::vector<std::string>
PVPathTransform::parsePath(std::string path) 
{
    std::vector<std::string> result;
    if(not path.size()) {
        return result;
    }
    if(path[0] != '/') {
        return result;
    }

    std::stringstream ss(path);
    std::string item;
    while(std::getline(ss, item, '/')) {
        result.push_back(item);
    }

    return result;

}

std::vector<G4VPhysicalVolume*> 
PVPathTransform::convertPathToPV(const std::vector<std::string>& path)
{
    std::vector<G4VPhysicalVolume*> result;

    std::vector<std::string>::const_iterator it=path.begin(), end=path.end();

    G4PhysicalVolumeStore* pvs = G4PhysicalVolumeStore::GetInstance();

    G4VPhysicalVolume* tmp_pv=NULL;
    for (; it != end; ++it) {
        tmp_pv = pvs->GetVolume(*it);
        if (tmp_pv) {
            result.push_back(tmp_pv);
        } else {
            // Throw exception
            throw new std::runtime_error("Can't find the PV: "+*it);
        }
    }

    return result;

}

G4AffineTransform
PVPathTransform::getGTL(const std::vector<G4VPhysicalVolume*>& pv) {
    G4AffineTransform result;
    // TODO
    // 1. check the first pv is world
    // 2. check the relation between pv

    // 3. compute the affine transform
    // From the second PV
    for (int i=1; i<pv.size(); ++i) {
        result.InverseProduct(G4AffineTransform(result), // previous
                              G4AffineTransform(         // current
                                  pv[i]->GetRotation(),
                                  pv[i]->GetTranslation()
                              ));
    }

    return result;
}

void 
PVPathTransform::quick_test() {

}
