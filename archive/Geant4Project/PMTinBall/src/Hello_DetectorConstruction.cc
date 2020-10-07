
#include "Hello_DetectorConstruction.hh"
#include "Hello_DetectorConstructionUtils.hh"

#include "G4Material.hh"
#include "G4Box.hh"
#include "G4Tubs.hh"
#include "G4LogicalVolume.hh" 
#include "G4ThreeVector.hh"  
#include "G4PVPlacement.hh"
#include "globals.hh"

#include "G4Colour.hh"
#include "G4VisAttributes.hh"

#include <sstream>

Hello_DetectorConstruction::Hello_DetectorConstruction()
{
  makeVariables();
  makeMaterial();
}


Hello_DetectorConstruction::~Hello_DetectorConstruction()
{

}

G4VPhysicalVolume*
Hello_DetectorConstruction::Construct()
{
  makeWorldLogical();
  makeWorldPhysical();

  makePMTLogical();
  makePMTPhysical();

  return experimentalHall_phys;
}

void 
Hello_DetectorConstruction::makeVariables()
{
  expHall_x = 15.0 * m;
  expHall_y = 15.0 * m;
  expHall_z = 15.0 * m;

  pmttube_r = 50.8*cm / 2;
  pmttube_h = 68.5*cm;

  ball_r = 10.0 * m;

  gap = 10 * mm;

}

void
Hello_DetectorConstruction::makeMaterial()
{
  Vacuum = new G4Material("Galatic",
                          1.,
                          1.01 * g/mole,
                          universe_mean_density,
                          kStateGas,
                          2.73 * kelvin,
                          3.e-18 * pascal);
  Al = new G4Material("Aluminium",
                      13.,
                      26.98*g/mole,
                      2.700*g/cm3);

}

G4LogicalVolume* 
Hello_DetectorConstruction::makeWorldLogical()
{
  G4Box* experimentalHall_box = new G4Box("expHall_box",
                                          expHall_x,
                                          expHall_y,
                                          expHall_z);
  experimentalHall_log = new G4LogicalVolume(
                                experimentalHall_box,
                                Vacuum,
                                "expHall_log",
                                0,
                                0,
                                0);
  return experimentalHall_log;
}

G4VPhysicalVolume* 
Hello_DetectorConstruction::makeWorldPhysical()
{
  experimentalHall_phys = new G4PVPlacement(0, 
                                            G4ThreeVector(),
                                            experimentalHall_log,
                                            "expHall",
                                            0, 
                                            false, 
                                            0); 
  return experimentalHall_phys;

}

G4LogicalVolume* 
Hello_DetectorConstruction::makePMTLogical()
{
  G4Tubs* pmttube_solid = new G4Tubs(
                                    "PMTTube",
                                    0*cm,  /* inner */ 
                                    pmttube_r, //21*cm/2, /* pmt_r */ 
                                    pmttube_h/2, //30*cm/2, /* pmt_h */ 
                                    0*deg, 
                                    360*deg);
  pmttube_log = new G4LogicalVolume(
                                    pmttube_solid, 
                                    Al/*Material*/, 
                                    "PMTTube_Logic");

  G4VisAttributes* pmttube_visatt = new G4VisAttributes(G4Colour(0.5, 0.5, 0.5));
  //pmttube_visatt -> SetForceWireframe(true);  
  //pmttube_visatt -> SetForceAuxEdgeVisible(true);
  pmttube_visatt -> SetForceSolid(true);
  pmttube_visatt -> SetForceLineSegmentsPerCircle(4);

  pmttube_log -> SetVisAttributes(pmttube_visatt);

  return pmttube_log;

}

G4VPhysicalVolume* 
Hello_DetectorConstruction::makePMTPhysical()
{
  G4int copyno = 0;

  // Calculate the PMT in r - theta
  G4int n_x_z = Utils::Ball::GetMaxiumNumInCircle(
                                                  ball_r,
                                                  pmttube_r,
                                                  gap);

  G4int n_x_z_half = n_x_z / 2;

  G4int n_theta_one_circle = n_x_z_half / 2 + 1;

  G4double per_theta = 2*pi / n_x_z;

  G4cout << "### n_x_z: " << n_x_z << G4endl;
  G4cout << "### n_x_z_half: " << n_x_z_half << G4endl;
  G4cout << "### n_theta_one_circle: " << n_theta_one_circle << G4endl;
  G4cout << "### per_theta: " << per_theta << G4endl;

  for (G4int theta_i = 0; theta_i < n_theta_one_circle; ++theta_i) {
    //G4double theta = per_theta * n_x_z_half/2;
    G4double theta = per_theta * theta_i;

    G4double small_theta = atan( pmttube_r / ball_r);

    G4cout << "Small theta: " << small_theta << G4endl;
    G4cout << "Theta: " << theta << G4endl;

    G4int n_one_circle = 1;
    G4double per_phi = 0;

    assert ( (0 <= theta) && (theta <=pi) );

    G4double theta_real=0;

    if ( theta < pi/2 ) {
      theta_real = theta - small_theta;
    } else if (theta >= pi/2) {
      theta_real = (pi - theta) - small_theta;
    }


    if ( (theta_real > small_theta) ) {

      assert ( (0 <= theta) && (theta <=pi) );

      G4cout << "Theta: " << theta_real << G4endl;

      G4double ball_r_x_y = ball_r * sin(theta_real);

      assert (ball_r_x_y >= 0 || printf("Ball_r_x_y: %g m\n", ball_r_x_y/m));

      // Calculate the r - phi
      // TODO
      // The gap is the gap between the small Rs.

      n_one_circle = Utils::Ball::GetMaxiumNumInCircle(
                                                    ball_r_x_y,
                                                    pmttube_r,
                                                    gap
                                                            );
      assert ( n_one_circle > 0 );
      per_phi = 2*pi / n_one_circle;

    } else {

    }


    for (G4int phi_i=0; phi_i < n_one_circle; ++phi_i) {

      G4double phi = per_phi * phi_i;


      G4double x = (pmttube_h/2 + ball_r) * sin(theta) * cos(phi);
      G4double y = (pmttube_h/2 + ball_r) * sin(theta) * sin(phi);
      G4double z = (pmttube_h/2 + ball_r) * cos(theta);

      G4ThreeVector pos(x, y, z);
      G4RotationMatrix rot;
      rot.rotateY(pi + theta);
      rot.rotateZ(phi);
      G4Transform3D trans(rot, pos);

      G4String pmtname;
      std::stringstream ss;
      ss << "PMTTube_" << copyno;
      ss >> pmtname;
      pmttube_phys = new G4PVPlacement(
                                      trans,
                                      pmttube_log,
                                      pmtname,
                                      experimentalHall_log, 
                                      false, 
                                      copyno); 
      ++copyno;
      if (copyno>10) {
          return pmttube_phys;
      }
    }
  }

  G4cout << "### Total PMTs: " << copyno << G4endl;

}
