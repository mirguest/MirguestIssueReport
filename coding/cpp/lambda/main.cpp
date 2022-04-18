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

struct InternalResult {
    template<typename T>
    T get(int i) const {
        T r{};
        return r;
    }
};

// Ref:
//     https://nilsdeppe.com/posts/tmpl-part3

template<size_t Index, size_t IndexR, typename TInput, typename... Args, std::enable_if_t<Index == 0>* = nullptr>
void tuple_element_helper(const TInput& ir, std::tuple<Args...>& tuple) {
}

template<size_t Index, size_t IndexR, typename TInput, typename... Args, std::enable_if_t<Index != 0>* = nullptr>
void tuple_element_helper(const TInput& ir, std::tuple<Args...>& tuple) {
    std::cout << " Index: " << Index << " IndexR: " << IndexR << std::endl;
    auto& v1 = std::get<IndexR>(tuple);
    typedef typename std::decay<decltype(v1)>::type T;
    auto v2 = ir.template get<T>(IndexR);

    std::cout << " tuple: " << std::get<IndexR>(tuple) << std::endl;

    tuple_element_helper<Index-1, IndexR+1>(ir, tuple);
}




template<typename... Args>
std::vector<std::tuple<Args...>> myquery2(const std::string& str) {
    typedef typename std::tuple<Args...> TupleT;

    std::vector<TupleT> results;

    for (int i = 0; i < 1; ++i) {
        TupleT t;

        InternalResult ir; // a runtime result

        tuple_element_helper<std::tuple_size_v<TupleT>, 0>(ir, t);

        results.push_back(t);
    }

    
    return results;
}

int main() {
    // myquery("abcd", [](int id) {
    //     std::cout << id << std::endl;
    // });

    // myquery("abcd", [](int id, const std::string& name) {
    //     std::cout << id << " " << name << std::endl;
    // });

    std::string stmt = "select id from table";
    
    auto results = myquery2<int>(stmt);

    for (auto result: results) {
        auto [id] = result;
        std::cout << " id: " << id << std::endl;
    }

    for (auto result: myquery2<int, double>(stmt)) {
        auto [id, x] = result;
        std::cout << " id: " << id << " x: " << x << std::endl;
    }

    // std::string stmt2 = "select id, name from table";

    // auto results2 = myquery2<int, std::string>(stmt2);

    // for (const auto& result: results2) {
    //     auto [id, name] = result;
    // }


}
