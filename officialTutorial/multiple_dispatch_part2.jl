using InteractiveUtils

versioninfo()
#=
Multiple dispatch is a key feature of Julia, that we will explore
It helps make software fast, It also makes software extensible, 
programmable, and downright fun to play with.

It may just hearld a breakthrough for parallel computation.
=#

# Let's define a new type to represent a Roman numerical. 
mutable struct Roman
    n::Int
end

#For coding simplicity, we'll just deal with numbers between 0 and 9
Base.show(io::IO, r::Roman) = print(io, 'ⅰ' + (r.n - 1) % 10 ) # 'ⅰ' is a Unicode Roman numeral

@show Roman(6) # creating object
@show typeof.([5 5.0 Roman(5) "Five" '5'  5//1])

# We would like to display it nicely, in Roman numerals:
romans = [1, 2, 3, 4, 5, 6, 7, 8, 9]
@show typeof(romans)
@show Roman.(romans) # equivalent to map(Roman, romans)

import Base: +, * 

+(a::Roman, b::Roman) = Roman(a.n + b.n)
*(a::Roman, b::Roman) = Roman(a.n * b.n)

@show Roman(3) + Roman(7)
@show Roman(7) * Roman(3)
@show Roman(3) ^ 2

#= 
@show Roman(3) * 2
ERROR: LoadError: MethodError: no method matching *(::Roman, ::Int64)
=#