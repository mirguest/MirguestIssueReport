#include <iostream>

#include "dummy.hh"
#include "Property.hh"

dummy::dummy() {
    pb_x = declareProperty("x", x);
    pb_y = declareProperty("y", y);
    pb_z = declareProperty("z", z);
    pb_u = declareProperty("u", u);
}

bool
dummy::run() {
    // Display x
    std::cout << "x: " << x << std::endl;
    // Display y
    std::cout << "y: " << y << std::endl;
    // Display z
    std::cout << "z: ";
    for (std::vector<int>::iterator i=z.begin(); i!=z.end(); ++i) {
        std::cout << *i << " ";
    }
    std::cout << std::endl;
    // Display u
    std::cout << "u: ";
    for (std::map<std::string, int>::iterator i=u.begin(); i!=u.end(); ++i) {
        std::cout << i->first << " " << i->second;
    }
    std::cout << std::endl;
    return true;
}

PropertyBase*
dummy::getx() {
    return pb_x;
}

PropertyBase*
dummy::gety() {
    return pb_y;
}

PropertyBase*
dummy::getz() {
    return pb_z;
}

PropertyBase*
dummy::getu() {
    return pb_u;
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
        .def("getz", &dummy::getz,
                return_value_policy<reference_existing_object>())
        .def("getu", &dummy::getu,
                return_value_policy<reference_existing_object>())
        .def("run", &dummy::run)
    ;
}
