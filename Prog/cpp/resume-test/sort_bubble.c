/*
 * =====================================================================================
 *
 *       Filename:  sort_bubble.c
 *
 *    Description:  bubble sort
 *                  https://en.wikipedia.org/wiki/Bubble_sort
 *        Version:  1.0
 *        Created:  2015年10月03日 21时13分42秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <stdbool.h>
#include "array_display.h"

void sort_bubble(int arr[], int len) {
    int i;
    int temp;
    int change;
    while (true) {
        change = false;
        for (i = 0; i < len-1; ++i) {
            if (arr[i+1] < arr[i]) {
                temp = arr[i+1];
                arr[i+1] = arr[i];
                arr[i] = temp;
                change = true;
            }
        }
        if (!change) {
            break;
        }
    }
}

int main() {
    int arr[] = {6, 5, 3, 1, 8, 7, 2, 4};
    int len = sizeof(arr)/sizeof(int);

    array_display(arr, len);
    sort_bubble(arr, len);
    array_display(arr, len);
}
