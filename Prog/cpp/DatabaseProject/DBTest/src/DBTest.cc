#include <iostream>
#include "DBTest.h"
#include "SniperKernel/AlgFactory.h"
#include "SniperKernel/SniperPtr.h"
#include "DatabaseSvc/IQuery.h"

DECLARE_ALGORITHM(DBTest);

DBTest::DBTest(const std::string& name)
    : AlgBase(name)
{

}

bool
DBTest::initialize() {
    return true;
}

bool
DBTest::execute() {
    SniperPtr<IQuery> query_svc(getScope(), "MyMongoDB");
    IQuery::QueryString querystr = "";
    IQuery::QueryResult results = query_svc->query(querystr);

    std::cout << "+ Result: " << std::endl;
    for (IQuery::QueryResult::iterator it = results.begin();
	 it != results.end();++it) {
      std::cout << (*it) << std::endl;
    }

    return true;
}

bool
DBTest::finalize() {
    return true;
}
