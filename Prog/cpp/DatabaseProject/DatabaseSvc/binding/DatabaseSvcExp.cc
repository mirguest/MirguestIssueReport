#include "boost/python.hpp"
#include "boost/noncopyable.hpp"
#include "boost/make_shared.hpp"
#include "boost/python/suite/indexing/vector_indexing_suite.hpp"
namespace bp = boost::python;
using namespace boost::python;

#include "SniperKernel/SvcBase.h"
#include "DatabaseSvc/IQuery.h"

struct IQueryWrap: IQuery, wrapper<IQuery>
{
    QueryResult query(const QueryString& qs) {
        return this->get_override("query")(qs);
    }
};

#include "MongoDB.h"

BOOST_PYTHON_MODULE(libDatabaseSvc)
{
    class_<IQuery::QueryResult>("QueryResult")
        .def(vector_indexing_suite<IQuery::QueryResult>());
    class_<IQueryWrap, boost::noncopyable>("IQuery")
        .def("query", pure_virtual(&IQuery::query));
    class_<MyMongoDB, bases<IQuery, SvcBase>, boost::noncopyable>
        ("MyMongDB", init<std::string>());
}
