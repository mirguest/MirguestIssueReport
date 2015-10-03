/*
 * =====================================================================================
 *
 *       Filename:  atoi.c
 *
 *    Description:  Convert string to int
 *
 *        Version:  1.0
 *        Created:  2015年10月03日 09时17分48秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdio.h>
#include <stdlib.h>

int myatoi(const char* str) {
    int val = 0;
    int sign = 1;

    // if negative number
    if (str && *str == '-') {
        sign = -1;
        ++str;
    }

    while (str && *str!='\0') {
        if ( *str < '0'  || *str > '9') {
            return 0;
        }
        val *= 10;
        val += (int)(*str-'0');

        ++str;
    }

    return sign*val;
}

int main() {
    printf("%d\n", myatoi("1234"));
    printf("%d\n", myatoi("-1234"));
    printf("%d\n", myatoi("notanumber"));

    return 0;
}
