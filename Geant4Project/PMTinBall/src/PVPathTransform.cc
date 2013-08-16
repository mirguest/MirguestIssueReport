
#include "PVPathTransform.hh"

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

PVPathTransform::Path2Trans PVPathTransform::s_p2t;

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
    char c;
    ss.get(c);

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
        G4cout << *it << G4endl;
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
    // 0. check size of pv
    if (not pv.size()) {
        return result;
    }
    // TODO
    // 1. check the first pv is world
    G4Navigator* nav = G4TransportationManager::GetTransportationManager()
                            ->GetNavigatorForTracking();
    G4VPhysicalVolume* world = nav->GetWorldVolume();

    if (pv[0] != world) {
        throw new std::runtime_error("The '"+pv[0]->GetName()+"' is not world PV");
    }
    // 2. check the relation between pv
    for (int i=0; i<pv.size()-1; ++i) {
        G4LogicalVolume* lv = pv[i]->GetLogicalVolume();
        // TODO
        // we can use IsAncestor to skip pvs' name
        if (lv->IsDaughter(pv[i+1])) {
            // It's OK
        } else {
            throw new std::runtime_error("The '"+pv[i+1]->GetName()
                                        +"' is not the daughter of PV "
                                        +pv[i]->GetName());
        }
    }

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
    std::string path = "/expHall/PMTTube_1";
    std::vector<std::string> result_path = parsePath(path);
    std::vector<G4VPhysicalVolume*> result_pv = convertPathToPV(result_path);

    G4AffineTransform gtl = getGTL(result_pv);

    // global to local
    G4cout << "Global to Local:" << G4endl;
    G4ThreeVector tvg(0,0,10.0*m+68.5*cm/2);
    G4cout << "Global: "<< tvg << G4endl;
    gtl.ApplyPointTransform(tvg);
    G4cout << "Local:" << tvg << G4endl;

    // local to global
    G4cout << "Local to Global:" << G4endl;
    G4ThreeVector tvl(0,0,0);
    G4cout << "Local:" << tvl << G4endl;
    gtl.Inverse().ApplyPointTransform(tvl);
    G4cout << "Global:" << tvl << G4endl;


    quick_test_2();
}

G4AffineTransform
PVPathTransform::GlobalToLocal(const std::string& path) {
    std::vector<std::string> result_path = parsePath(path);
    std::vector<G4VPhysicalVolume*> result_pv = convertPathToPV(result_path);

    G4AffineTransform gtl = getGTL(result_pv);
    return gtl;
}

G4AffineTransform
PVPathTransform::LocalToGlobal(const std::string& path) {
    return GlobalToLocal(path).Inverse();
}

void 
PVPathTransform::quick_test_2() {
    std::string path = "/World/SteelBall/LS/Module_3/PMT_5";
    std::string exists_path;
    std::vector<std::string> residual_path;

    checkInCache(path, exists_path, residual_path);

    G4cout << "Exists Path: " << exists_path << G4endl;
    std::copy(residual_path.begin(), 
              residual_path.end(), 
              std::ostream_iterator<std::string>(G4cout, " "));
    G4cout << std::endl;
}

// return true if find the exists_path in cache
// else return false
bool
PVPathTransform::checkInCache(const std::string& input_path, 
                              std::string& exists_path,
                              std::vector<std::string>& residual_path) {
    bool result = false;

    std::string path = input_path;
    std::string base;
    while(path.size()>1) {
        // 0. the path starts with '/'
        // 1. check the path exists in cache
        if (s_p2t.count(path)) {
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
        G4cout << __LINE__ << " BASE: " << base << G4endl;
        residual_path.push_back(base);
        path = path.substr(0, found);
        G4cout << __LINE__ << " PATH: " << path << G4endl;
    }

    return result;
}

