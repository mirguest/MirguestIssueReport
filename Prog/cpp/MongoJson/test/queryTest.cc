#include <iostream>
#include <DB/IQuery.h>
#include "MongoDB.h"
int main() {
    MyMongoDB* mymongo = new MyMongoDB;
    IQuery* querySvc = mymongo;

    std::cout << "BEGIN Query Test" << std::endl;
    IQuery::QueryString querystr = "";
    std::cout << "+ Construct Query Str: " << querystr << std::endl;
    IQuery::QueryResult results = querySvc->query(querystr);
    std::cout << "+ Result: " << std::endl;

    // release
    delete mymongo;
}
