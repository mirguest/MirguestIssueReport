#include "PVPathTransformV2.hh"

#include <sstream>
#include <exception>
#include <stdexcept>
#include <algorithm>
#include <iterator>

#include "G4LogicalVolume.hh"
#include "G4VPhysicalVolume.hh"
#include "G4PhysicalVolumeStore.hh"
#include "globals.hh"

#include "G4TransportationManager.hh"
#include "G4Navigator.hh"

PVPathTransformV2::Path2AT PVPathTransformV2::s_p2at;
PVPathTransformV2::Path2PV PVPathTransformV2::s_p2pv;

PVPathTransformV2&
PVPathTransformV2::getInstance() {
    static PVPathTransformV2 pvpt;
    return pvpt;
}

PVPathTransformV2::PVPathTransformV2() {}

G4AffineTransform 
PVPathTransformV2::GlobalToLocal(const std::string& path) {
    return getGTL(path);
}

G4AffineTransform 
PVPathTransformV2::LocalToGlobal(const std::string& path) {
    return getGTL(path).Inverse();
}

G4AffineTransform
PVPathTransformV2::getGTL(const std::string& path) {
    std::string exists_path;
    std::vector<std::string> residual_path;

    bool exists = checkInCache(path, exists_path, residual_path);

    // Begin to get the transform
    G4VPhysicalVolume* volume_start = NULL;
    G4VPhysicalVolume* tmp_pv = NULL;
    G4AffineTransform at_start;

    if (exists) {
        volume_start = s_p2pv[exists_path];
        at_start = s_p2at[exists_path];
    }

    G4PhysicalVolumeStore* pvs = G4PhysicalVolumeStore::GetInstance();
    // Loop the residual path
    while(residual_path.size()) {
        std::string current_base = residual_path.back();
        residual_path.pop_back();
        tmp_pv = pvs->GetVolume(current_base);

        if (volume_start==NULL) {
            // check tmp_pv is world?
        } else {
            // check whether volume_start is the mother of tmp_pv
            G4LogicalVolume* lv = volume_start->GetLogicalVolume();
            // TODO
            // we can use IsAncestor to skip pvs' name
            if (lv->IsDaughter(tmp_pv)) {
                // It's OK
            } else {
                throw new std::runtime_error("The '"+tmp_pv->GetName()
                                            +"' is not the daughter of PV "
                                            +volume_start->GetName());
            }
        }

        at_start.InverseProduct(
                    G4AffineTransform(at_start),
                    G4AffineTransform(
                        tmp_pv->GetRotation(),
                        tmp_pv->GetTranslation()
                    )
                );
        exists_path += "/"+current_base;
        s_p2at[exists_path] = at_start;
        s_p2pv[exists_path] = tmp_pv;
        volume_start = tmp_pv;
    }
    return at_start;
}

bool
PVPathTransformV2::checkInCache(const std::string& input_path, 
                                std::string& exists_path,
                                std::vector<std::string>& residual_path) {
    bool result = false;

    std::string path = input_path;
    std::string base;
    while(path.size()>1) {
        // 0. the path starts with '/'
        // 1. check the path exists in cache
        if (s_p2at.count(path)) {
            exists_path = path;
            result = true;
            break;
        }
        // 2. get the dirname of path
        unsigned found = path.find_last_of('/');
        if (found == std::string::npos or found > path.size()) {
            // can't find any more
            break;
        }
        base = path.substr(found+1);
        residual_path.push_back(base);
        path = path.substr(0, found);
    }

    return result;

}
