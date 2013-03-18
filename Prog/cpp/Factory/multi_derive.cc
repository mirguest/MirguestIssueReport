
class I1 {
public:
    virtual int m1() = 0;
};

class I2 {
public:
    virtual int m2() = 0;
};

class C: public I1, public I2 {
public:
    int m1() {return 1;}
    int m2() {return 2;}
};

int main()
{
    I1* i1 = new C;
    I2* i2 = dynamic_cast<I2*>(i1);

    i1->m1();
    i2->m2();

}
