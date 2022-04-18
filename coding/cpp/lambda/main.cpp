#include <iostream>
#include <type_traits>



template<typename Func>
void myquery(const std::string& str, Func f) {
    // f(1, str);
    std::cout << typeid(typename std::decay<Func>::type).name() << std::endl;
}

int main() {
    myquery("abcd", [](int id) {
        std::cout << id << std::endl;
    });

    myquery("abcd", [](int id, const std::string& name) {
        std::cout << id << " " << name << std::endl;
    });

}
