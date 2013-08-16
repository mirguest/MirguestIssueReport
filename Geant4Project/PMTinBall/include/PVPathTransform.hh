#ifndef PVPathTransform_hh
#define PVPathTransform_hh

#include <map>
#include <vector>
#include <string>

#include "G4ThreeVector.hh"
#include "G4AffineTransform.hh"

class G4VPhysicalVolume;

class PVPathTransform {

public:
    typedef std::map< std::string, G4AffineTransform > Path2Trans;
    typedef std::map< std::string, G4VPhysicalVolume* > Path2PV;
    void quick_test();
    G4AffineTransform quick_test_2(const std::string& path);
    void show_test_info(const G4AffineTransform&, G4ThreeVector tv);

    G4AffineTransform GlobalToLocal(const std::string&);
    G4AffineTransform LocalToGlobal(const std::string&);

    std::vector<std::string> parsePath(std::string);
    std::vector<G4VPhysicalVolume*> convertPathToPV(const std::vector<std::string>&);

    G4AffineTransform getGTL(const std::vector<G4VPhysicalVolume*>&);

private:
    bool checkInCache(const std::string& input_path, 
                      std::string& exists_path,
                      std::vector<std::string>& residual_path);
private:
    static Path2Trans s_p2t;
    static Path2PV s_p2pv;
};

#endif
