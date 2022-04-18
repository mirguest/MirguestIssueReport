#include <iostream>
#include <type_traits>
#include <vector>
#include <tuple>
#include <functional>

template<typename Func>
void myquery(const std::string& str, Func f) {
    // f(1, str);
    std::cout << typeid(typename std::decay<Func>::type).name() << std::endl;
}

template<typename... Args>
std::vector<std::tuple<Args...>> myquery2(const std::string& str) {
    typedef typename std::tuple<Args...> TupleT;

    std::vector<TupleT> results;

    for (int i = 0; i < 10; ++i) {
        TupleT t;

        results.push_back(t);
    }

    
    return results;
}

int main() {
    myquery("abcd", [](int id) {
        std::cout << id << std::endl;
    });

    myquery("abcd", [](int id, const std::string& name) {
        std::cout << id << " " << name << std::endl;
    });

    std::string stmt = "select id from table";
    
    auto results = myquery2<int>(stmt);

    for (const auto& result: results) {
        auto [id] = result;
    }

    std::string stmt2 = "select id, name from table";

    auto results2 = myquery2<int, std::string>(stmt2);

    for (const auto& result: results2) {
        auto [id, name] = result;
    }


}
