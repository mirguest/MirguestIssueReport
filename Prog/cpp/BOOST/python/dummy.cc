#include <iostream>
#include "dummy.hh"
#include "property.hh"

dummy::dummy() {
    pb_x = declareProperty("x", x);
}

MyProperty*
dummy::getx() {
    return pb_x;
}

bool
dummy::run() {
    // Display x
    std::cout << "x: " << x << std::endl;
}

#include <boost/python.hpp>
#include <boost/noncopyable.hpp>
using namespace boost::python;

void
dummy::exportPythonAPI() {
    class_<dummy, boost::noncopyable>("dummy")
        .def("getx", &dummy::getx,
                return_value_policy<reference_existing_object>())
        .def("run", &dummy::run)
    ;

}
