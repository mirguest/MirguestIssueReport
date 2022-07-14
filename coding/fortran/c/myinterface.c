#include "myinterface.h"
#include <iostream>

Pod global_pod;


void init() {
    finit();
}

void execute() {
    fexecute();
}

void set_pod(float x, float y, float z, float t) {
    std::cout << "invoke set_pod..." << std::endl;
    std::cout << "x/y/z/t: "
              << x << " " << y << " " << z << " " << t
              << std::endl;
    global_pod.x = x;
    global_pod.y = y;
    global_pod.z = z;
    global_pod.t = t;
}

void get_pod(Pod* pod) {
    pod->x = global_pod.x;
    pod->y = global_pod.y;
    pod->z = global_pod.z;
    pod->t = global_pod.t;
}
