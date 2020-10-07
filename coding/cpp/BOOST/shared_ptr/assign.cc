#include <iostream>
#include <boost/shared_ptr.hpp>

class C {
public:
    C():m_count(0) {
        std::cout << "Ctor: " << m_count << std::endl;
    }

    ~C(){
        std::cout << "Dtor: " << m_count << std::endl;
    }

    C(const C& c):
        m_count(c.m_count+1) {
        std::cout << "Copy Cotr: " << m_count << std::endl;
    }

private:
    int m_count;
};

typedef boost::shared_ptr<C> CPtr;

int main()
{
    std::cout << "main begin" << std::endl;
    CPtr  c(new C);

    CPtr c2;

    c2 = c;
    std::cout << "main end" << std::endl;
}
