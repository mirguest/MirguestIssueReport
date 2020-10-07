
#include <string>
#include <boost/python.hpp>

namespace bp = boost::python;

class C {
public:
    bp::object get() {
        return bp::list(std::string("x"));
    }
};

BOOST_PYTHON_MODULE(hello)
{

    bp::class_<C>("C")
        .def("get", &C::get);

}
