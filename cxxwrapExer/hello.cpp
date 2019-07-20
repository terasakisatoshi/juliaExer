#include <string>
#include "jlcxx/jlcxx.hpp"
using namespace std;

std::string greet() {
    return "Hello world";
}

JLCXX_MODULE define_julia_module(jlcxx::Module& mod)
{
    mod.method("greet", &greet);
}