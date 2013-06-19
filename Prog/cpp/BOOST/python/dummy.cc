#include <iostream>
#include "dummy.hh"
#include "property.hh"

dummy::dummy() {
    pb_x = declareProperty("x", x);
    pb_y = declareProperty("y", y);
    pb_v_x = declareProperty("vx", v_x);
    pb_v_y = declareProperty("vy", v_y);
    pb_m_x = declareProperty("mx", m_x);
    pb_m_y = declareProperty("my", m_y);
}

MyProperty*
dummy::getx() {
    return pb_x;
}

MyProperty*
dummy::gety() {
    return pb_y;
}

MyProperty*
dummy::getvx() {
    return pb_v_x;
}

MyProperty*
dummy::getvy() {
    return pb_v_y;
}

MyProperty*
dummy::getmx() {
    return pb_m_x;
}

MyProperty*
dummy::getmy() {
    return pb_m_y;
}

bool
dummy::run() {
    // Display x
    std::cout << "x: " << x << std::endl;
    // Display y
    std::cout << "y: " << y << std::endl;

    // Display vx
    std::cout << "vx: ";
    for(std::vector<int>::iterator it = v_x.begin();
            it != v_x.end();
            ++it) {
        std::cout << *it << " ";
    }
    std::cout << std::endl;

    // Display vy
    std::cout << "vy: ";
    for(std::vector<double>::iterator it = v_y.begin();
            it != v_y.end();
            ++it) {
        std::cout << *it << " ";
    }
    std::cout << std::endl;

    // Display mx
    std::cout << "mx: ";
    for(std::map<std::string, int>::iterator it = m_x.begin();
            it != m_x.end();
            ++it) {
        std::cout << it->first << ": " << it->second << " ";
    }
    std::cout << std::endl;

    // Display my
    std::cout << "my: ";
    for(std::map<std::string, double>::iterator it = m_y.begin();
            it != m_y.end();
            ++it) {
        std::cout << it->first << ": " << it->second << " ";
    }
    std::cout << std::endl;
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
        .def("getvx", &dummy::getvx,
                return_value_policy<reference_existing_object>())
        .def("getvy", &dummy::getvy,
                return_value_policy<reference_existing_object>())
        .def("getmx", &dummy::getmx,
                return_value_policy<reference_existing_object>())
        .def("getmy", &dummy::getmy,
                return_value_policy<reference_existing_object>())
        .def("run", &dummy::run)
    ;

}
