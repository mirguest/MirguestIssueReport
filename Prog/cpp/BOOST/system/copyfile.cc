/*
 * $ g++ copyfile.cc -lboost_filesystem -lboost_system
 */

#include <boost/filesystem.hpp>

int main() {
    std::string from_filename("hello.txt");
    std::string to_filename("exist.txt");
    try {
        boost::filesystem::copy_file( from_filename, to_filename );
    } catch (...) {

    }
}
