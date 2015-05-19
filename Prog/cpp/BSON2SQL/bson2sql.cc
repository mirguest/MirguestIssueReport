#include <cstdlib>
#include <iostream>
#include <string>
#include <set>
#include "mongo/client/dbclient.h" // for the driver

#include "mongo/db/json.h"
#include "mongo/bson/bsonobj.h"
#include "mongo/bson/bsonelement.h"

namespace mongo {
    typedef BSONObj bo;
    typedef BSONElement be;
}

bool json2str(const std::string& jsonstr, std::string& str) {
    mongo::bo mybo = mongo::fromjson ( jsonstr ) ;
    std::set<std::string> fields;
    mybo.getFieldNames(fields);

    for (std::set<std::string>::iterator it = fields.begin();
            it != fields.end(); ++it) {
        std::cout << *it << std::endl;
        mongo::be elem = mybo[*it];
        
        std::cout << elem.toString(false) << std::endl;
    }
    return true;
}

int main() {

    std::string jsonstr = "{\"name\":\"JUNO\", \"age\": 25}";

    std::string str;

    json2str(jsonstr, str);
}
