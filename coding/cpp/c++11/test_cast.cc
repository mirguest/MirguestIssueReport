#include<iostream>

class Base {
protected:
    int protected_member;
public:
    Base(int value) : protected_member(value) {}
};;

class Derived : public Base {
public:
    void setProtectedMember(int value) {
        protected_member = value;
    }

    int getProtectedMember() {
        return protected_member;
    }
};

int main() {
    Base* pb = new Base(42);
    Derived* pd = static_cast<Derived*>(pb);

    pd->setProtectedMember(10);
    std::cout << "Protected Member: " << pd->getProtectedMember() << std::endl;

    return 0;
}