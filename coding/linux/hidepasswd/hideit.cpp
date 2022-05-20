
/*
 * $ g++ -o hideit hideit.cpp
 * $ hideit 
 *
 * $ ps aux | grep hideit
 */

#include <iostream>

int main(int argc, char* argv[]) {

    if (argc != 2) {
        std::cerr << "please give password" << std::endl;
        return -1;
    }
    std::string password;
    // load password 
    password = argv[1];
    // overwrite the password
    // see rdesktop: rdesktop.c
    // case 'p'
    char* p = argv[1];
    while (*p)
        *(p++) = 'X';

    // wait.
    // now, please use ps to check.
    for (;;) {

    }

    return 0;
}
