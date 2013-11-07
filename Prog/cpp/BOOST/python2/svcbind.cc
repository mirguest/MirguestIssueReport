#include "interface.h"
#include "svcbase.h"
#include "svcimpl.h"

#include "boost/python.hpp"
#include "boost/noncopyable.hpp"
#include "boost/make_shared.hpp"

namespace bp = boost::python;
using namespace boost::python;

svcbase* createSvc() {
    return new svcimpl;
}

BOOST_PYTHON_MODULE(svc) {
    
    def("create_svc", &createSvc,
        return_value_policy<reference_existing_object>())
    ;

    class_<svcimpl, bases<svcbase, interface> >
        ("svcimpl")
    ;
}
