#include <mongo/client/dbclient.h>
#include "MongoDB.h"

MyMongoDB::MyMongoDB()
  : m_conn(0){
    mongo::client::initialize();
    m_conn = new mongo::DBClientConnection;
}

MyMongoDB::~MyMongoDB() {
    delete m_conn;
}
