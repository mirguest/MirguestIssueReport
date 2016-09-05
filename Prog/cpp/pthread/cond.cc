#include <pthread.h>
#include <cstdio>
#include <cstdlib>

pthread_cond_t ready_slaves = PTHREAD_COND_INITIALIZER;
pthread_cond_t ready_master = PTHREAD_COND_INITIALIZER;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

// const int N = 10;
const int N = 10;
int count = 0;

void* f_master(void*) {
    // init
    
    //
    while (true) {
        printf("[master] current count: %d\n", count);
        pthread_mutex_lock(&lock);
        // all slaves are ready
        printf("[master] current count: %d\n", count);
        if (count == N) {
            pthread_mutex_unlock(&lock);
            break;
        }
        // wait for slave
        printf("[master] waiting for slave...\n");
        pthread_cond_wait(&ready_slaves, &lock);
        printf("[master] ready slave...\n");
        pthread_mutex_unlock(&lock);
    }

    printf("final count: %d\n", count);

    pthread_mutex_lock(&lock);
    pthread_cond_broadcast(&ready_master);
    pthread_mutex_unlock(&lock);
}

void* f_slave(void*) {
    // init
    //
    // execute
    // double result = 0;
    printf("[slave] start...\n");
    // for (int i = 0; i < 100000; ++i) {
    //     result += i; 
    // }
    printf("[slave] start barrier...\n");
    //
    pthread_mutex_lock(&lock);
    ++count;
    // tell master slave is ok
    printf("[slave] ready slave... %d\n", count);
    pthread_cond_broadcast(&ready_slaves);
    // waiting master ready
    printf("[slave] waiting for master...\n");
    pthread_cond_wait(&ready_master, &lock);
    printf("[slave] done...\n");
    pthread_mutex_unlock(&lock);
}

int main() {
    
    pthread_t t_master;
    pthread_t t_slaves[N];

    printf("creating master...\n");
    pthread_create(&t_master, NULL, f_master, NULL);

    printf("creating slaves...\n");
    for (int i = 0; i < N; ++i) {
        pthread_create(&t_slaves[i], NULL, f_slave, NULL);
    }

    for (int i = 0; i < N; ++i) {
        pthread_join(t_slaves[i], NULL);
    }
    pthread_join(t_master, NULL);
}
