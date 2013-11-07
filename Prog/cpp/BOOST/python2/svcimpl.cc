#include "svcimpl.h"

interface::~interface() {

}

svcbase::~svcbase() {

}

bool
svcimpl::init() {
    return true;
}

int
svcimpl::xxx() {
    return 42;
}
