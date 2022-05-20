#ifndef Hello_cc
#define Hello_cc

namespace World {

struct HelloPar {
    int x;
    int y;
};

class Hello {
public:
    void hello(); 

    int add(int x, int y);

    int add2(HelloPar& hp);
};

}

#endif
