/*
 * =====================================================================================
 *
 *       Filename:  itoa.c
 *
 *    Description:  Convert int to string
 *                  Need to revert the string
 *        Version:  1.0
 *        Created:  2015年10月03日 09时33分21秒
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

char* myitoa(int val, char* str) {
    char bufarray[256];
    char* buf = bufarray;
    int len = 0;

    int sign = val>=0? 1: -1;
    val *= sign;

    while (val && len < 256) {
        *buf++ = val%10 + '0';
        ++len;
        val /= 10;
    }


    if (sign<0) {
        *buf++ = '-';
        ++len;
    }

    while (len--) {
        *str++ = *--buf;
    }

    *str = '\0';

}

int main() {
    char str[10];
    myitoa(1234, str);
    printf("%s\n", str);
    myitoa(-1234, str);
    printf("%s\n", str);
    return 0;
}
