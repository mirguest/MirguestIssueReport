/*
 * =====================================================================================
 *
 *       Filename:  sort_heap.c
 *
 *    Description:  heap sort   
 *                  https://en.wikipedia.org/wiki/Heapsort
 *        Version:  1.0
 *        Created:  2015年10月03日 22时21分06秒
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

int heap[256];

void insert_heap(int arr[], int idx, int number) {
    // heap starts from 1.
    idx = idx+1;
    if (idx >= 256) { return; }
    int parent = idx/2;
    while (parent) {
        if (number > arr[parent]) {
            arr[idx] = arr[parent];

            idx = parent;
            parent = idx/2;
        } else {
            break;
        }
    }
    arr[idx] = number;
}

int heap_pop(int len) {
    int maxval = heap[1];

    int last = heap[len];
    len = len - 1;

    int parent = 1;
    int idx = 2;
    // adjust the heap
    while (idx <= len) {
        if (idx < len && heap[idx] < heap[idx+1]) {
            ++idx;
        }

        if (last >= heap[idx]) {
            break;
        }

        heap[parent] = heap[idx];
        parent = idx;
        idx *= 2;
    }

    heap[parent] = last;

    return maxval;
}

void sort_heap(int arr[], int len) {
    // construct heap
    int i;
    for (i = 0; i < len; ++i) {
        printf("heap: \n");
        insert_heap(heap, i, arr[i]);
        array_display(heap, 1+i+1);
    }
    // sort
    for (i = 0; i < len; ++i) {
        printf("sort: \n");
        arr[i] = heap_pop(len-i);
        array_display(arr, i+1);
    }
}

int main() {
    int arr[] = {6, 5, 3, 1, 8, 7, 2, 4};
    int len = sizeof(arr)/sizeof(int);

    array_display(arr, len);
    sort_heap(arr, len);
    array_display(arr, len);
}
