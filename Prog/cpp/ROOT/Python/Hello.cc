#include "Hello.h"

namespace World {

void
Hello::hello (){
    return;
}

int 
Hello::add (int x, int y) {
    return x + y;
}

int 
Hello::add2(HelloPar& hp) {
    return hp.x + hp.y;
}

}
