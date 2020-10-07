#include <string>
#include <iostream>
#include <boost/filesystem.hpp>

/*
 * $ g++ tmpfile.cc -lboost_filesystem -lboost_system
 */

int main() {
    boost::filesystem::path temp = boost::filesystem::unique_path();
    const std::string tempstr    = temp.native();  // optional
    std::cout << "Temp file: " << tempstr << std::endl;
}
