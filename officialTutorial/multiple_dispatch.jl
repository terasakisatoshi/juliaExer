# Multiple dispatch
#https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/10.%20Multiple%20dispatch.ipynb

using InteractiveUtils
versioninfo()


#= 
In this script we'll explore multiple dispatch, which is as key 
feature of Julia.

Multiple dispatch makes software generic and fast!

Starting with the familiar
=#

f(x) = x^2

#=
We could declare functions in Julia without giving Julia any
information about the types of the input arguments that
function will receive.
And then Julia will determine on its own which input argument
types make sense and which do not.
=#

@show f(10)
@show f([1 2; 3 4])

#=
However, we also have the option to tell Julia explicitly what types
our input arguments are allowed to have.
=#

foo(x::String, y::String) = println("My inputs x=$x and y=$y are both strings")
foo("Hello","Hi")
foo(x::Int, y::Int) = println("My inputs x=$x and y=$y are both integers")
foo(3, 4) #Now function `foo` works on integers!
foo("Hello","World") # But look!, `foo` also still works when `x` and `y` are strings!

@show methods(foo)
#=
So, we now call `foo` function on integers or strings. When you call
`foo` on a particular set of arguments, Julia will infer the types of the inputs and dispatch
the appropriate method. This is multiple dispatch
=#

println(@which foo(3,4))

#=
And we can continue to add other methods to our generic function `foo`.
Let's add one that takes the abstract type `Number`, which includes subtypes such as 
`Int`, `Float64`, and other objects you would think of as numbers:
=#

foo(x::Number, y::Number) = println("My inputs x=$x and y=$y are both numbers!")
foo(3,4)
foo(3.0,4.0)

#=
We can also add a fallback, duck-typed method for `foo` that takes inputs of any type:
=#

foo(x,y)=println("I accept inputs of any type!!!",typeof(x),typeof(y))

v = rand(3)
foo(v,v)

#= output
Julia Version 0.7.0
Commit a4cb80f3ed (2018-08-08 06:46 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin14.5.0)
  CPU: Intel(R) Core(TM) M-5Y51 CPU @ 1.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.0 (ORCJIT, broadwell)
f(10) = 100
f([1 2; 3 4]) = [7 10; 15 22]
My inputs x=Hello and y=Hi are both strings
My inputs x=3 and y=4 are both integers
My inputs x=Hello and y=World are both strings
methods(foo) = # 2 methods for generic function "foo":
[1] foo(x::Int64, y::Int64) in Main at /Users/terasakisatoshi/work/juliaLang/officialTutorial/multiple_dispatch.jl:37
[2] foo(x::String, y::String) in Main at /Users/terasakisatoshi/work/juliaLang/officialTutorial/multiple_dispatch.jl:35
foo(x::Int64, y::Int64) in Main at /Users/terasakisatoshi/work/juliaLang/officialTutorial/multiple_dispatch.jl:37
My inputs x=3 and y=4 are both integers
My inputs x=3.0 and y=4.0 are both numbers!
I accept inputs of any type!!!Array{Float64,1}Array{Float64,1}
=#