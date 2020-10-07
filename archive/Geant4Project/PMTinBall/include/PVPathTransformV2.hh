#ifndef PVPathTransformV2_hh
#define PVPathTransformV2_hh

#include <map>
#include <vector>
#include <string>

#include "G4ThreeVector.hh"
#include "G4AffineTransform.hh"

class G4VPhysicalVolume;

class PVPathTransformV2 {

public:
    typedef std::map< std::string, G4AffineTransform > Path2AT;
    typedef std::map< std::string, G4VPhysicalVolume* > Path2PV;

    static PVPathTransformV2& getInstance();

    G4AffineTransform GlobalToLocal(const std::string&);
    G4AffineTransform LocalToGlobal(const std::string&);

private:
    PVPathTransformV2();
    PVPathTransformV2(const PVPathTransformV2&);
    PVPathTransformV2& operator=(const PVPathTransformV2&);

private:
    G4AffineTransform getGTL(const std::string& path);
    bool checkInCache(const std::string& input_path, 
                      std::string& exists_path,
                      std::vector<std::string>& residual_path);

private:
    static Path2AT s_p2at;
    static Path2PV s_p2pv;
    
};

#endif
