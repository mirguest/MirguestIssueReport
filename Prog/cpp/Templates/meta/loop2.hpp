#ifndef LOOP2_HPP
#define LOOP2_HPP

template <int DIM, typename T>
class DotProduct {
    public:
        static T result (T* a, T* b) {
            return *a * *b + DotProduct<DIM-1,T>::result(a+1,b+1);
        }
};

template <typename T>
class DotProduct<1, T> {
    public:
        static T result (T* a, T* b) {
            return *a * *b;
        }
};

template <int DIM, typename T>
inline T dot_product(T* a, T* b) {
    return DotProduct<DIM,T>::result(a,b);
}

#endif
