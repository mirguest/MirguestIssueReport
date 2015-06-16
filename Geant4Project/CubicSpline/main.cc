#include "G4DataInterpolation.hh"
#include "globals.hh"
#include <iostream>

int main() {

    static double s_theta[] = { 0.*deg, 9.*deg, 18.*deg, 27.*deg, 36.*deg, 45.*deg, 54.*deg, 63.*deg, 72.*deg, 81.*deg, 90.*deg, };
    static double s_ce[] =    { 0.8,    0.98,   0.9,     0.87,    0.97,    0.93,    1.0,     0.77,    0.79,    0.33,    0.};

    G4DataInterpolation di(s_theta, s_ce, 11, 0, 0);

    double delta = 90.*deg / 1000;
    for (int i = 0; i < 1000; ++i) {
        double k = (i*delta);
        double v = di.CubicSplineInterpolation( k );
        std::cout << k << " " << v << std::endl;
    }
}
