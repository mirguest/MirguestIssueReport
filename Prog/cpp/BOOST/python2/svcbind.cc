#include "interface.h"
#include "svcbase.h"
#include "svcimpl.h"

#include "boost/python.hpp"
#include "boost/noncopyable.hpp"
#include "boost/make_shared.hpp"

namespace bp = boost::python;
using namespace boost::python;

struct svcbaseWrap: svcbase, wrapper<svcbase>
{
    bool init() {
        return this->get_override("init")();
    }
};

struct interfaceWrap: interface, wrapper<interface>
{
    int xxx() {
        return this->get_override("xxx")();
    }
};

svcbase* createSvc() {
    return new svcimpl;
}

BOOST_PYTHON_MODULE(svc) {
    class_<svcbaseWrap, boost::shared_ptr<svcbaseWrap>, boost::noncopyable>
        ("svcbase")
        .def("init", pure_virtual(&svcbase::init))
    ;

    class_<interfaceWrap, boost::shared_ptr<interfaceWrap>, boost::noncopyable>
        ("interface")
        .def("xxx", pure_virtual(&interface::xxx))
    ;
    
    def("create_svc", &createSvc,
        return_value_policy<reference_existing_object>())
    ;

    class_<svcimpl, bases<svcbase, interface> >
        ("svcimpl")
    ;
}
