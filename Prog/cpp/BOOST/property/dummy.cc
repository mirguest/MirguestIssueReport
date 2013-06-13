#include "dummy.hh"
#include "Property.hh"

dummy::dummy() {
    pb_x = declareProperty("x", x);
}
