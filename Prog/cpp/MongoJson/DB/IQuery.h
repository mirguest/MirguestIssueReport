#ifndef DB_IQuery_h
#define DB_IQuery_h

#include <string>
#include <vector>
class IQuery {
public:
    typedef std::string QueryString;
    typedef std::vector<std::string> QueryResult;

    virtual QueryResult query(const QueryString& qs) = 0;

};

#endif
