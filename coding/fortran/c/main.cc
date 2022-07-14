/*
 * An example to do following:
 *   - invoke a C wrapper to init
 *   - C wrapper invoke Fortran function
 *   - invoke a C wrapper to execute
 *   - C wrapper invoke Fortran function and get a returned object
 *
 */



#include "myinterface.h"

int main() {
    init();

    execute();
}
