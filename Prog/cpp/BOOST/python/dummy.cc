#include <iostream>
#include "dummy.hh"
#include "property.hh"

dummy::dummy() {
    pb_x = declareProperty("x", x);
    pb_y = declareProperty("y", y);
}

MyProperty*
dummy::getx() {
    return pb_x;
}

MyProperty*
dummy::gety() {
    return pb_y;
}

bool
dummy::run() {
    // Display x
    std::cout << "x: " << x << std::endl;
    // Display y
    std::cout << "y: " << y << std::endl;
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
        .def("run", &dummy::run)
    ;

}
