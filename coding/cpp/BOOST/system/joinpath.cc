#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main ()
{
    fs::path dir ("/tmp");
    fs::path file ("foo.txt");
    fs::path full_path = dir / file;
    std::cout << full_path << std::endl;

    std::string base = "$RECTIMELIKEALGROOT/share";

    std::cout << (fs::path(base) / fs::path("new_test_66MeV.root")).string() << std::endl;
    std::cout << (fs::path(base) / "new_test_66MeV.root").string() << std::endl;
}

