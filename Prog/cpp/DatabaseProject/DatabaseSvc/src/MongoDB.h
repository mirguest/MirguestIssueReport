#ifndef src_MongoDB_h
#define src_MongoDB_h

#include <DatabaseSvc/IQuery.h>
#include <DatabaseSvc/IUpdate.h>
#include <DatabaseSvc/IInsert.h>
#include <SniperKernel/SvcBase.h>

namespace mongo {
    class DBClientConnection;
}

class MyMongoDB: public IQuery, public IInsert, public IUpdate, public SvcBase {
public:
    MyMongoDB(const std::string& name);
    ~MyMongoDB();

    bool initialize();
    bool finalize();

    IQuery::QueryResult query(const IQuery::QueryString& qs);
    bool update(const IUpdate::QueryString& qs, const IUpdate::RecordString& rs);
    bool insert(const IInsert::RecordString& rs);

private:

    std::string m_hostname;
    std::string m_dbname;
    mongo::DBClientConnection* m_conn;

};

#endif
