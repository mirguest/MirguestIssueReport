#include <mongo/client/dbclient.h>
#include "MongoDB.h"
#include <iostream>

MyMongoDB::MyMongoDB()
  : m_hostname("localhost"), m_conn(0){
    mongo::client::initialize();
    m_conn = new mongo::DBClientConnection;

    m_conn->connect(m_hostname);

    m_dbname = "mydb.testData";
}

MyMongoDB::~MyMongoDB() {
    std::cout << "MyMongoDB::~MyMongoDB() Begin" << std::endl;
    delete m_conn;
    std::cout << "MyMongoDB::~MyMongoDB() End" << std::endl;
}

MyMongoDB::QueryResult 
MyMongoDB::query(const MyMongoDB::QueryString& qs) {
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
