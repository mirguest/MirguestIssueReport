
#include "globals.hh"
#include "PMTinTube_DetectorConstruction.hh"

#include "PMTinTube_DetectorMessenger.hh"

#include "G4Box.hh"
#include "G4Tubs.hh"
#include "G4Trd.hh"
#include "G4LogicalVolume.hh"
#include "G4PVPlacement.hh"
#include "G4Material.hh"

#include "G4Colour.hh"
#include "G4VisAttributes.hh"

#include "G4GeometryManager.hh"

#include <cmath>


PMTinTube_DetectorConstruction::PMTinTube_DetectorConstruction()
{
    DefineMaterials();
    DefineVariables();

}


PMTinTube_DetectorConstruction::~PMTinTube_DetectorConstruction()
{

}

G4VPhysicalVolume*
PMTinTube_DetectorConstruction::Construct()
{
    CreateLogicalWorld();
    CreateLogicalPMTTube();
    CreateLogicalOpticalTrd();

    return world_physi;
}

void
PMTinTube_DetectorConstruction::DefineMaterials()
{
    Vacuum = new G4Material("Vacuum", 
                            1., 
                            1.01*g/mole,
                            universe_mean_density,
                            kStateGas,
                            2.73*kelvin,
                            3.e-18*pascal);
    Al = new G4Material("Aluminium", 13., 26.98*g/mole, 2.700*g/cm3);
}

void
PMTinTube_DetectorConstruction::DefineVariables()
{
    //world_size = G4ThreeVector(10*m, 10*m, 10*m);

    //pmt_place_r = 4*m;
    //pmt_place_gap = 1*cm;

    world_size = G4ThreeVector(40*m, 40*m, 40*m);
    pmt_place_r = 15.5*m;
    pmt_place_h = 31*m;
    pmt_place_gap = 1*cm;
    //pmt_place_gap = 40*cm;

    pmttube_r = 50.8*cm / 2; // 20 inch
    pmttube_h = 68.5*cm;

    opttrd_d = pmttube_r*2*(sqrt(2) - 1);
    opttrd_h = 20 * cm;

    m_det_msg = new PMTinTube_DetectorMessenger(this);
    m_opt_trd_on_off = true;
}

void 
PMTinTube_DetectorConstruction::CreateLogicalWorld() {
    
    world_solid = new G4Box("World", 
                            world_size.x()/2,
                            world_size.y()/2,
                            world_size.z()/2);
    world_logic = new G4LogicalVolume(world_solid,
                                      Vacuum,
                                      "World");
    world_physi = new G4PVPlacement(0,
                                    G4ThreeVector(),
                                    world_logic,
                                    "World",
                                    0,
                                    false,
                                    0);
}

void
PMTinTube_DetectorConstruction::CreateLogicalPMTTube()
{
    pmttube_solid = new G4Tubs(
                              "PMTTube",
                              0*cm,  /* inner */
                              pmttube_r, //21*cm/2, /* pmt_r */
                              pmttube_h/2, //30*cm/2, /* pmt_h */
                              0*deg,
                              360*deg
                              );

    //pmttube_r = pmttube_solid->GetOuterRadius();
    //pmttube_h = pmttube_solid->GetZHalfLength() * 2;


    pmttube_logic = new G4LogicalVolume(
                                        pmttube_solid,
                                        Al/*Material*/,
                                        "PMTTube_Logic");
    /* Set Vis Attributes */

    G4VisAttributes* pmttube_visatt = new G4VisAttributes(G4Colour(1., 0., 0.));
    //pmttube_visatt -> SetForceWireframe(true);
    pmttube_visatt -> SetForceSolid(true);
    pmttube_visatt -> SetForceLineSegmentsPerCircle(4);

    pmttube_logic -> SetVisAttributes(pmttube_visatt);

    /* Place The PMT Tube */

    G4VPhysicalVolume* pmttube_physi;

    G4int n_one_circle = GetMaxiumNinCircle(
                                            pmt_place_r, 
                                            pmttube_r, 
                                            pmt_place_gap);
    //n_one_circle = 4;

    G4double per_theta = 2*pi/n_one_circle;

    G4int n_half_height = GetMaxiumNinHalfHeight(pmt_place_h,
                                            pmttube_r,
                                            pmt_place_gap);


    G4cout << "LINTAO::MESSAGE::CreateLogicalPMTTube" << G4endl;
    G4cout << "LINTAO::MESSAGE::CreateLogicalPMTTube:: "
           << "One circle:" << n_one_circle << G4endl;
    G4cout << "LINTAO::MESSAGE::CreateLogicalPMTTube:: "
           << "Half Height:" << n_half_height << G4endl;

    G4double per_h = 2*pmttube_r + pmt_place_gap;

    G4int cur = 2;
    G4int plusneg[] = {1, -1};
    G4int copyno = 0;
    for (G4int height_i=0; height_i < n_half_height+1; ++height_i) {
        G4double abs_cur_z = height_i * per_h;

        for (G4int index=0; index<cur; ++index) {
            for (G4int theta_i=0; theta_i < n_one_circle; ++theta_i) {
                G4double theta = per_theta * theta_i;
                G4double x = (pmttube_h/2 + pmt_place_r) * cos(theta);
                G4double y = (pmttube_h/2 + pmt_place_r) * sin(theta);
                G4double z = abs_cur_z * plusneg[index];
                G4ThreeVector pos(x, y, z);
                G4RotationMatrix rot;
                rot.rotateY(pi * 1.5);
                rot.rotateZ(theta);
                G4Transform3D trans(rot, pos);
                pmttube_physi = new G4PVPlacement(
                                                trans,
                                                pmttube_logic,
                                                "PMTTube",
                                                world_logic,
                                                false,
                                                copyno);
                pmttubes_physi.push_back(pmttube_physi);
                ++copyno;
            }

            // If height_i == 0, it means in center!
            if (height_i == 0) {
                break;
            }
        }

    }

    G4cout << "LINTAO::MESSAGE::CreateLogicalPMTTube" << G4endl;
    G4cout << "LINTAO::MESSAGE::CreateLogicalPMTTube:: copyno:"<< copyno << G4endl;

    //G4cout << "LINTAO::MESSAGE::CreateLogicalPMTTube:: remove copy no" << G4endl;

    //for (G4int i=0; i<copyno/100; ++i) {
    //    RemovePMTPhysicalVolumeByCopyNo(i);
    //}
}

G4int
PMTinTube_DetectorConstruction::GetMaxiumNinCircle(
        G4double r_tube, G4double r_pmt, G4double gap
        )
{
    G4int N=0;
    G4double theta = 2 * atan(r_pmt / r_tube);
    G4double phi = 2* asin(gap / (2*sqrt(r_pmt*r_pmt + r_tube*r_tube)));
    N = int(2*pi / (theta + phi));
    return N;
}

G4int 
PMTinTube_DetectorConstruction::GetMaxiumNinHalfHeight(
        G4double h, G4double r, G4double gap)
{
    return int(0.5 * (h - 2*r -2*gap)/(2*r+gap));
}

void
PMTinTube_DetectorConstruction::RemovePMTPhysicalVolumeByCopyNo(G4int copyno)
{
    // Open Geometry
    G4GeometryManager::GetInstance()->OpenGeometry(world_physi);

    G4VPhysicalVolume* current_physi = pmttubes_physi[copyno];
    G4LogicalVolume* mother = current_physi -> GetMotherLogical();

    if (mother->IsDaughter(current_physi)) {
        G4cout << "LINTAO::MESSAGE::RemovePMTPhysicalVolumeByCopyNo" << G4endl;
        G4cout << "LINTAO::MESSAGE::RemovePMTPhysicalVolumeByCopyNo:: is daughter: Yes"<< G4endl;
        mother -> RemoveDaughter(current_physi);
    }


    // Close Geometry
    G4GeometryManager::GetInstance()->CloseGeometry(world_physi);

}

void
PMTinTube_DetectorConstruction::AddPMTPhysicalVolumeByCopyNo(G4int copyno)
{
    // Open Geometry
    G4GeometryManager::GetInstance()->OpenGeometry(world_physi);

    G4VPhysicalVolume* current_physi = pmttubes_physi[copyno];
    G4LogicalVolume* mother = current_physi -> GetMotherLogical();

    if (!mother->IsDaughter(current_physi)) {
        G4cout << "LINTAO::MESSAGE::AddPMTPhysicalVolumeByCopyNo" << G4endl;
        G4cout << "LINTAO::MESSAGE::AddPMTPhysicalVolumeByCopyNo::" << copyno << " is not daughter"<< G4endl;
        mother -> AddDaughter(current_physi);
    }


    // Close Geometry
    G4GeometryManager::GetInstance()->CloseGeometry(world_physi);


}

void 
PMTinTube_DetectorConstruction::CreateLogicalOpticalTrd()
{
    /* Get The OptTrd Solid */
    opttrd_solid = new G4Trd(
                            "OptTrd",
                            opttrd_d / 2,
                            0,
                            opttrd_d / 2,
                            0,
                            opttrd_h / 2
                            );

    /* Get The OptTrd Logical Volume */
    opttrd_logic = new G4LogicalVolume(
                                        opttrd_solid,
                                        Al,
                                        "OptTrd_Logic");

    G4VisAttributes* opttrd_visatt = new G4VisAttributes(G4Colour(0.5, 0.5, 0.5));
    opttrd_visatt -> SetForceWireframe(true);
    //opttrd_visatt -> SetForceSolid(true);
    opttrd_visatt -> SetForceAuxEdgeVisible(true);
    //opttrd_visatt -> SetForceLineSegmentsPerCircle(4);

    opttrd_logic -> SetVisAttributes(opttrd_visatt);


    /* Place The Opt Trd */

    G4VPhysicalVolume* opttrd_physi;

    /* calculate the number of Opt Trd in One Circle */

    G4int n_one_circle = GetMaxiumNinCircle(
                                            pmt_place_r, 
                                            pmttube_r, 
                                            pmt_place_gap);
    G4double per_theta = 2*pi/n_one_circle;
    G4double start_theta = per_theta / 2;

    /* calculate the number of Opt Trd in Half Height of the Tube */

    G4int n_half_height = GetMaxiumNinHalfHeight(pmt_place_h,
                                            pmttube_r,
                                            pmt_place_gap);
    G4double per_h = 2*pmttube_r + pmt_place_gap;
    G4double opttrd_start_h = per_h / 2;

    G4int cur = 2;
    G4int plusneg[] = {1, -1};
    G4int copyno = 0;
    for (G4int height_i=0; height_i < n_half_height+1; ++height_i) {
        G4double abs_cur_z = opttrd_start_h + height_i * per_h;

        for (G4int index=0; index<cur; ++index) {
            for (G4int theta_i=0; theta_i < n_one_circle; ++ theta_i) {
                G4double theta = start_theta + per_theta * theta_i;

                G4double x = (pmt_place_r - opttrd_h/2) * cos(theta);
                G4double y = (pmt_place_r - opttrd_h/2) * sin(theta);
                G4double z = abs_cur_z * plusneg[index];
                G4ThreeVector pos(x, y, z);
                G4RotationMatrix rot;
                rot.rotateZ(pi * 0.25);
                rot.rotateY(pi * 1.5);
                rot.rotateZ(theta);
                G4Transform3D trans(rot, pos);

                opttrd_physi = new G4PVPlacement(
                                                trans,
                                                opttrd_logic,
                                                "OptTrd",
                                                world_logic,
                                                false,
                                                copyno
                                                );
                opttrds_physi.push_back(opttrd_physi);
                ++copyno;
            }
        }
    }

}


void 
PMTinTube_DetectorConstruction::RemoveLogicalOpticalTrd()
{
    G4cout << "LINTAO::MESSAGE::RemoveLogicalOpticalTrd: Try to Remove Optical Trd" << G4endl;
    // Open Geometry
    G4GeometryManager::GetInstance()->OpenGeometry(world_physi);
    vector< G4VPhysicalVolume* >::iterator iter = opttrds_physi.begin();
    for (; iter != opttrds_physi.end(); ++iter) {
        G4VPhysicalVolume* cur = (*iter);
        G4LogicalVolume* mother = cur -> GetMotherLogical();

        if (mother->IsDaughter(cur)) {
            G4cout << "LINTAO::MESSAGE::RemoveLogicalOpticalTrd" << G4endl;
            G4cout << "LINTAO::MESSAGE::RemoveLogicalOpticalTrd:: is daughter: Yes"<< G4endl;
            mother -> RemoveDaughter(cur);
        }
    }
    // Close Geometry
    G4GeometryManager::GetInstance()->CloseGeometry(world_physi);

}


void 
PMTinTube_DetectorConstruction::AddLogicalOpticalTrd()
{
    G4cout << "LINTAO::MESSAGE::AddLogicalOpticalTrd: Try to Add Optical Trd" << G4endl;
    // Open Geometry
    G4GeometryManager::GetInstance()->OpenGeometry(world_physi);
    vector< G4VPhysicalVolume* >::iterator iter = opttrds_physi.begin();
    for (; iter != opttrds_physi.end(); ++iter) {
        G4VPhysicalVolume* cur = (*iter);
        G4LogicalVolume* mother = cur -> GetMotherLogical();

        // Only the current logical volume is not the daughter, we add it.
        if (!mother->IsDaughter(cur)) {
            G4cout << "LINTAO::MESSAGE::AddLogicalOpticalTrd" << G4endl;
            G4cout << "LINTAO::MESSAGE::AddLogicalOpticalTrd:: is daughter: No"<< G4endl;
            mother -> AddDaughter(cur);
        }
    }
    // Close Geometry
    G4GeometryManager::GetInstance()->CloseGeometry(world_physi);

}

void 
PMTinTube_DetectorConstruction::ModifyHeightLogicalOpticalTrd(G4double height)
{
    if (height <=0) {
        return;
    }
    G4cout << "LINTAO::MESSAGE::ModifyHeightLogicalOpticalTrd: Try to Modify Height of Optical Trd" << G4endl;
    G4cout << "LINTAO::MESSAGE::ModifyHeightLogicalOpticalTrd: Height of Optical Trd = "<< height << G4endl;
    opttrd_h = height;
    // Open Geometry
    G4GeometryManager::GetInstance()->OpenGeometry(world_physi);
    vector< G4VPhysicalVolume* >::iterator iter = opttrds_physi.begin();
    for (; iter != opttrds_physi.end(); ++iter) {
        G4VPhysicalVolume* cur = (*iter);
        G4LogicalVolume* mother = cur -> GetMotherLogical();

        // Only the current logical volume is the daughter, we modify it.
        if (mother->IsDaughter(cur)) {
            G4cout << "LINTAO::MESSAGE::ModifyHeightLogicalOpticalTrd" << G4endl;
            G4cout << "LINTAO::MESSAGE::ModifyHeightLogicalOpticalTrd:: is daughter: Yes"<< G4endl;
            
            G4LogicalVolume* cur_log = cur -> GetLogicalVolume();
            Helper_ModifyOptTrdHeight(cur_log);
            Helper_ModifyOptTrdPosition(cur);
        }
    }
    // Close Geometry
    G4GeometryManager::GetInstance()->CloseGeometry(world_physi);


}

void 
PMTinTube_DetectorConstruction::Helper_ModifyOptTrdHeight(G4LogicalVolume* cur_log) {
    G4Trd* trd_solid = (G4Trd*)(cur_log -> GetSolid());
    // Set New Value.
    trd_solid -> SetZHalfLength(opttrd_h / 2);
}

void 
PMTinTube_DetectorConstruction::Helper_ModifyOptTrdPosition(G4VPhysicalVolume* cur_phy) {
    G4cout << "LINTAO::MESSAGE::Helper_ModifyOptTrdHeight:" << G4endl;
    // TODO
    // How to move to the right position
    G4ThreeVector old_pos = cur_phy -> GetTranslation();
    G4double old_x = old_pos.x();
    G4double old_y = old_pos.y();
    G4double old_r = sqrt(old_x*old_x + old_y*old_y);

    G4double sin_theta = old_y / old_r;
    G4double cos_theta = old_x / old_r;

    G4double new_r = pmt_place_r - opttrd_h/2;
    G4double new_x = cos_theta * new_r;
    G4double new_y = sin_theta * new_r;

    old_pos.setX(new_x);
    old_pos.setY(new_y);

    cur_phy -> SetTranslation(old_pos);
}

void 
PMTinTube_DetectorConstruction::UIOptTrdOn() 
{
    /* if opttrd is already on, we just return; */
    if (m_opt_trd_on_off) {
        return;
    }
    AddLogicalOpticalTrd();
    m_opt_trd_on_off = true;
}

void 
PMTinTube_DetectorConstruction::UIOptTrdOff() 
{
    /* if opttrd is on, we need to remove it; */
    if (m_opt_trd_on_off) {
        RemoveLogicalOpticalTrd();
        m_opt_trd_on_off = false;
    }

}

void
PMTinTube_DetectorConstruction::UIOptTrdHeight(G4double height) 
{
    /* if opttrd is on, we will try to modify the height */
    if (m_opt_trd_on_off) {
        ModifyHeightLogicalOpticalTrd(height);
    } else {
        G4cout << "LINTAO::WARNING:" 
            << "There are no Opt Trd, I won't modify the height"
            << G4endl;
    }


}
