#include <pthread.h>
#include <cstdio>
#include <cstdlib>

static pthread_barrier_t barrier;
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

// const int N = 10;
const int N = 10;
int count = 0;

void* f_master(void*) {
    // init
    
    pthread_barrier_wait(&barrier);

    printf("final count: %d\n", count);

}

void* f_slave(void*) {
    pthread_mutex_lock(&lock);
    ++count;
    // tell master slave is ok
    pthread_mutex_unlock(&lock);

    pthread_barrier_wait(&barrier);
}

int main() {
    
    pthread_t t_master;
    pthread_t t_slaves[N];

    printf("creating master...\n");
    pthread_create(&t_master, NULL, f_master, NULL);

    pthread_barrier_init(&barrier, NULL, N+1);
    printf("creating slaves...\n");
    for (int i = 0; i < N; ++i) {
        pthread_create(&t_slaves[i], NULL, f_slave, NULL);
    }

    for (int i = 0; i < N; ++i) {
        pthread_join(t_slaves[i], NULL);
    }
    pthread_join(t_master, NULL);
}
