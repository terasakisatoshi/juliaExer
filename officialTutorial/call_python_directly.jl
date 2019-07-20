#https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/09.%20Julia%20is%20fast.ipynb

using PyCall
using Libdl

py"""
def pysum(arr):
    s=0
    for a in arr:
        s+=a
    return s
"""

pysum=py"pysum"

@show pysum([1,2,3,4,5])

py"""
class Goma():
    def __init__(self,msg):
        self.msg=msg
    def say_msg(self):
        return " ".join([self.msg,'Goma goma kyukkyu'])
"""

Goma = py"Goma"
goma = Goma("Hi")
@show goma[:say_msg]()

C_code = """
#include<stddef.h>
double c_sum(size_t n, double *X){
    double s = 0.0;
    for(size_t i=0; i<n; ++i){
        s += X[i];
    }
    return s;
}
"""

const C_lib = tempname()
open(`gcc -fPIC -O3 -msse3 -xc -shared -o $(C_lib * "." * dlext) -`, "w") do f
    print(f, C_code)
end

c_sum(X::Array{Float64}) = ccall(("c_sum", C_lib), Float64, (Csize_t, Ptr{Float64}), length(X), X)
@show c_sum([1.0,2.0,3.0,4.0,5.0])

using InteractiveUtils
versioninfo()

#= output
pysum([1, 2, 3, 4, 5]) = 15
(goma[:say_msg])() = "Hi Goma goma kyukkyu"
c_sum([1.0, 2.0, 3.0, 4.0, 5.0]) = 15.0
Julia Version 0.7.0
Commit a4cb80f3ed (2018-08-08 06:46 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin14.5.0)
  CPU: Intel(R) Core(TM) M-5Y51 CPU @ 1.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.0 (ORCJIT, broadwell)
[Finished in 9.8s]
=#