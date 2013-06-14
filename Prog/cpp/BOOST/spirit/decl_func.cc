
typedef int f(double);

int x(double) {

}

int g( int(double) ) {

}

template<typename T>
int gg(T) {

}

int main () {
    g(x);

    gg<int(double)>(x);

}
