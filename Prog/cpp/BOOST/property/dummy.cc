#include "dummy.hh"
#include "Property.hh"

dummy::dummy() {
    pb_x = declareProperty("x", x);
    pb_y = declareProperty("y", y);
}

PropertyBase*
dummy::getx() {
    return pb_x;
}

PropertyBase*
dummy::gety() {
    return pb_y;
}

#include <boost/python.hpp>
#include <boost/noncopyable.hpp>
using namespace boost::python;

void
dummy::exportPythonAPI() {
    class_<dummy, boost::noncopyable>("dummy")
        .def("getx", &dummy::getx,
                return_value_policy<reference_existing_object>())
        .def("gety", &dummy::gety,
                return_value_policy<reference_existing_object>())
    ;
}
