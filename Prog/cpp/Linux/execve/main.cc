/*
 * Note, if we try to run the program which is a script,
 * we must make sure the first line is the form:
 *      #! interpreter
 *
 * I create two shell scripts (with +x mode) 
 *  * one is with #! --> OK
 *  * another don't have --> Fail
 */

#include <unistd.h>

int main(int argc, char* argv[]) {

    const char* filename;
    char* argv2[2];

    if (argc == 1) {
        return 0;
    }

    filename = argv[1];
    argv2[0] = argv[1];
    argv2[1] = 0;

    execve(filename, argv2, 0);
}
