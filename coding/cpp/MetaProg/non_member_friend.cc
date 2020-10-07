namespace nmff {
    
template <class T>
struct signed_number {
    friend T abs(T x) {
        return x < 0 ? -x : x;
    }
};

}

class Float: nmff::signed_number<Float>
{
public:
    Float(float x)
        : value(x)
    {}

    Float operator-() const
    {
        return Float(-value);
    }

    bool operator<(float x) const
    {
        return value < x;
    }
    float value;
};

int main() {
    Float const minus_pi = -3.14;
    Float const pi = abs(minus_pi);

}
