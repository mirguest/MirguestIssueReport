#ifndef property_hh
#define property_hh

#include <boost/python.hpp>

namespace bp = boost::python;

class MyProperty {
public:

    void modify(bp::object& other);
    void show(); 


private:
    bp::object m_value;

};

#endif
