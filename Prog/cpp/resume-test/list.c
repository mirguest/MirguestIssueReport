/*
 * =====================================================================================
 *
 *       Filename:  list.c
 *
 *    Description:  list
 *
 *        Version:  1.0
 *        Created:  2015年10月03日 15时46分46秒
 *       Revision:  none
 *       Compiler:  gcc -std=c99
 *
 *         Author:  Tao Lin (), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <stdio.h>
#include <stdlib.h>

struct element {
    int key;
};

struct list_node {
    struct element *item;
    struct list_node* next;
};

typedef struct list {
    struct list_node* first;
} list;

/* create */
list list_create() {
    list l;
    l.first = NULL;
    return l;
}

/* append */
void list_append(list* l, struct element* elem) {
    struct list_node* p = NULL;

    // create a new node
    p = malloc(sizeof(struct list_node));
    p->item = elem;
    p->next = NULL;
    // append it to the list
    struct list_node** tail = &l->first;
    while (*tail) {
        tail = &(*tail)->next;
    }

    *tail = p;
}

/* insert */
void list_insert(list* l, int idx, struct element* elem) {
    struct list_node* p = NULL;
    // create a new node
    p = malloc(sizeof(struct list_node));
    p->item = elem;
    p->next = NULL;
    // insert into 
    struct list_node** tail = &l->first;
    int i = 0;
    while (*tail && i++ < idx) {
        tail = &(*tail)->next;
    }

    p->next = *tail;
    *tail = p;
}


/* delete */
void list_delete(list* l, struct element* elem) {
    struct list_node** tail = &l->first;
    while (*tail) {
        // find the object
        if ((*tail)->item == elem) {
            struct list_node* p = *tail;
            *tail = (*tail)->next;
            // release the node, but not the element
            free(p);
            break;
        }
        tail = &(*tail)->next;
    }
}

/* length */
int list_length(const list* l) {
    int len = 0;
    struct list_node* p = l->first;
    while (p) {
        ++len;
        p = p->next;
    }

    return len;
 }

/* visit */
typedef void (*list_visitor_func)(struct list_node*);

void list_visit(list* l, list_visitor_func func) {
    struct list_node* p = l->first;
    while(p) {
        func(p);
        p = p->next;
    }
}

/* display */
void list_display(const list* l) {
    struct list_node* p = l->first;
    while(p) {
        printf("%d\n", p->item->key);
        p = p->next;
    }
}

void list_visitor_dispaly(struct list_node* p) {
    if (p) {
        printf("%d ", p->item->key);
    }
}

/* reverse */
void list_reverse(list* l) {
    struct list_node** tail = &l->first;
    struct list_node* new_node = NULL;
    while(*tail) {
        struct list_node* p = (*tail);
        // remove the current node
        *tail = (*tail)->next;
        // attach the new node to current node, make it as a new node
        p->next = new_node;
        new_node = p;
    }

    *tail = new_node;
}

int main() {
    list l = list_create();

    struct element* elems[10];
    for (int i = 0; i < 10; ++i) {
        elems[i] = malloc(sizeof(struct element));
        elems[i]->key = i;
    }

    list_append(&l, elems[3]);
    list_append(&l, elems[8]);

    list_display(&l);

    list_insert(&l, 0, elems[9]);
    list_visit(&l, list_visitor_dispaly);
    printf("\n");

    int len = list_length(&l);
    printf("length: %d\n", len);

    list_insert(&l, 42, elems[7]);
    list_visit(&l, list_visitor_dispaly);
    printf("\nlength: %d\n", list_length(&l));

    list_insert(&l, 2, elems[2]);
    list_visit(&l, list_visitor_dispaly);
    printf("\nlength: %d\n", list_length(&l));

    list_delete(&l, elems[3]);
    list_visit(&l, list_visitor_dispaly);
    printf("\nlength: %d\n", list_length(&l));

    list_reverse(&l);
    list_visit(&l, list_visitor_dispaly);
    printf("\nlength: %d\n", list_length(&l));
    return 0;
}
