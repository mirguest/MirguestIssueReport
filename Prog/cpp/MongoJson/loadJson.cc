#include <cstdlib>
#include <iostream>
#include <string>
#include "mongo/client/dbclient.h" // for the driver

#include "mongo/db/json.h"

int main() {

    std::string jsonstr = "{\"name\":\"lintao\", \"age\": 25}";

    mongo::bo mybo = mongo::fromjson ( jsonstr ) ;
    mongo::be name = mybo["name"];
    mongo::be age = mybo["age"];

    std::cout << name.String() << std::endl;
    std::cout << age.Int() << std::endl;
}
