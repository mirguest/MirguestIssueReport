/*
 * =====================================================================================
 *
 *       Filename:  array_display.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2015年10月03日 20时57分35秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include <stdio.h>

void array_display(int arr[], int len) {
    for (int i = 0; i < len; ++i) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}
