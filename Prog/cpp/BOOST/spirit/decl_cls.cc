
class Base {
public:
    typedef Base base_type;
};

class Derived: public Base {
    Derived()
        : Derived::base_type() {

    }
};

int main() {

}
