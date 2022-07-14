/*
 * An example to do following:
 *   - invoke a C wrapper to init
 *   - C wrapper invoke Fortran function
 *   - invoke a C wrapper to execute
 *   - C wrapper invoke Fortran function and get a returned object
 *
 */



#include "myinterface.h"

#include <iostream>

int main() {
    init();

    execute();
    Pod pod;
    get_pod(&pod);

    std::cout << "Pod: " 
              << " x: " << pod.x
              << " y: " << pod.y
              << " z: " << pod.z
              << " t: " << pod.t
              << std::endl;

}
