
#include <TUUID.h>
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/uuid/uuid_io.hpp> 

int main() {
    boost::uuids::random_generator generator;
    boost::uuids::uuid uuid1 = generator();

    std::string uuid_str = to_string(uuid1);

    TUUID uuid_root;
    uuid_root.SetUUID(uuid_str.c_str());

    std::cout << uuid_root.AsString() << std::endl;
}
