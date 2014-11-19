#include <mongo/client/dbclient.h>
#include "MongoDB.h"
#include <iostream>

#include "SniperKernel/SvcFactory.h"
#include "SniperKernel/SniperLog.h"

DECLARE_SERVICE(MyMongoDB);

MyMongoDB::MyMongoDB(const std::string& name)
  : SvcBase(name), m_hostname("localhost"), m_conn(0){
    mongo::client::initialize();
    declProp("Hostname", m_hostname);
    declProp("DBName", m_dbname = "mydb.testData");
}

MyMongoDB::~MyMongoDB() {
    std::cout << "MyMongoDB::~MyMongoDB() Begin" << std::endl;
    if (m_conn) {
        delete m_conn;
    }
    std::cout << "MyMongoDB::~MyMongoDB() End" << std::endl;
}

IQuery::QueryResult 
MyMongoDB::query(const IQuery::QueryString& qs) {
    MyMongoDB::QueryResult result;
    
    std::auto_ptr<mongo::DBClientCursor> cursor = m_conn->query(
                                          m_dbname, 
                                          mongo::fromjson(qs));

    while ( cursor->more() ) {
        mongo::BSONObj obj = cursor->next();
        result.push_back(obj.jsonString());
    }

    return result;
} 

bool
MyMongoDB::update(const IUpdate::QueryString& qs, const IUpdate::RecordString& rs)
{
    return true;
}

bool
MyMongoDB::insert(const IInsert::RecordString& rs)
{
    m_conn -> insert(m_dbname, mongo::fromjson(rs));
    return true;
}

bool
MyMongoDB::initialize() {
    m_conn = new mongo::DBClientConnection;

    m_conn->connect(m_hostname);
    return true;
}

bool
MyMongoDB::finalize() {
    return true;
}
