#include <iostream>
#include "DBTest.h"
#include "SniperKernel/AlgFactory.h"
#include "SniperKernel/SniperPtr.h"
#include "DatabaseSvc/IQuery.h"
#include "DatabaseSvc/IInsert.h"
#include "DatabaseSvc/IUpdate.h"

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
    test_insert();
    test_update();
    test_query();
    return true;
}

bool
DBTest::finalize() {
    return true;
}

void
DBTest::test_insert() {
    SniperPtr<IInsert> insert_svc(getScope(), "MyMongoDB");
    IInsert::RecordString rs = "{\"age\":42}";
    insert_svc->insert(rs);
}

void
DBTest::test_update() {
    SniperPtr<IUpdate> update_svc(getScope(), "MyMongoDB");
    IUpdate::QueryString qs = "{\"age\":42}";
    IUpdate::RecordString rs = "{\"age\":24}";
    update_svc->update(qs, rs);

}

void
DBTest::test_query() {
    SniperPtr<IQuery> query_svc(getScope(), "MyMongoDB");
    IQuery::QueryString querystr = "";
    IQuery::QueryResult results = query_svc->query(querystr);

    std::cout << "+ Result: " << std::endl;
    for (IQuery::QueryResult::iterator it = results.begin();
	 it != results.end();++it) {
      std::cout << (*it) << std::endl;
    }

}
