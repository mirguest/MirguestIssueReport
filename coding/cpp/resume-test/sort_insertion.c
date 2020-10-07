/*
 * =====================================================================================
 *
 *       Filename:  sort_insertion.c
 *
 *    Description:  insertion sort
 *                  https://en.wikipedia.org/wiki/Insertion_sort
 *        Version:  1.0
 *        Created:  2015年10月03日 20时48分23秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include "array_display.h"

void sort_insertion(int arr[], int len) {
    int i;
    int j;
    for (i = 1; i < len; ++i) {
        int cur = arr[i];
        for (j = i-1; j >= 0 && cur < arr[j]; --j) {
            arr[j+1] = arr[j];
        }
        arr[j+1] = cur;
    }
}

int main() {
    int arr[] = {6, 5, 3, 1, 8, 7, 2, 4};
    int len = sizeof(arr)/sizeof(int);

    array_display(arr, len);
    sort_insertion(arr, len);
    array_display(arr, len);
}
