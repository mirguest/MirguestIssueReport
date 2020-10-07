/*
 * =====================================================================================
 *
 *       Filename:  sort_quick.c
 *
 *    Description:  quick sort
 *                  https://en.wikipedia.org/wiki/Quicksort
 *        Version:  1.0
 *        Created:  2015年10月03日 21时35分57秒
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

void sort_quick_impl(int arr[], int left, int right) {
    if (left >= right) {
        return;
    }
    // array_display(arr, 8);
    int pivot = arr[left];
    int i = left + 1;
    int j = right;
    while (i<j) {
        while (arr[i] < pivot) {
            ++i;
        }
        while (arr[j] > pivot) {
            --j;
        }
        if (i<j) {
            // swap i and j
            int tmp = arr[i];
            arr[i] = arr[j];
            arr[j] = tmp;
        }
    }
    if (arr[left] > arr[j]) {
        // swap pivot and j
        int tmp = arr[left];
        arr[left] = arr[j];
        arr[j] = tmp;
    }

    sort_quick_impl(arr, left, j-1);
    sort_quick_impl(arr, j+1, right);
    
}

void sort_quick(int arr[], int len) {
    sort_quick_impl(arr, 0, len-1);
}

int main() {
    int arr[] = {6, 5, 3, 1, 8, 7, 2, 4};
    int len = sizeof(arr)/sizeof(int);

    array_display(arr, len);
    sort_quick(arr, len);
    printf("sort:\n");
    array_display(arr, len);
}
