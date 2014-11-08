#ifndef src_MongoDB_h
#define src_MongoDB_h

#include <DB/IQuery.h>

namespace mongo {
    class DBClientConnection;
}

class MyMongoDB: public IQuery {

    MyMongoDB();
    ~MyMongoDB();

    QueryResult query(const QueryResult& qs);

private:

    std::string m_hostname;
    mongo::DBClientConnection* m_conn;

};

#endif
