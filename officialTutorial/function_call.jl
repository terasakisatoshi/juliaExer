function f(x)
    x^2
end

@show f(42)

function goma(msg)
    println("Hi $msg goma")
end 

gomagoma(msg) = println("Hi $msg gomagoma")

gomagomakyukkyu = msg -> println("Hi $msg gomagomakyukkyu")

goma("kyui")
gomagoma("kyui")
gomagomakyukkyu("kyui")

A = rand(3,3)
@show f(A)

# Mutating vs. non-mutating functions
#By convention, functions followed by ! alter their contents and functions lacking ! do not.
#For example, let's look at the difference between `sort` and `sort!`.

v = [3, 5, 2]
@show sort(v)
@show v
@show sort!(v)
@show v


#=
`map` is a "higher-order" function 
in Julia that takes a function as one of its output arguments.
=#

map(f,[1,2,3])

# this will give us an output array where the function `f` has been applied to all elements of `[1,2,3]`

@show map(f, [1, 2, 3])
@show [f(1), f(2), f(3)]

# we could have 
@show map(x-> x^3, [1, 2, 3])

@show broadcast(f, [1,2,3])
@show f.([1,2,3])

A = [i+3j for j in 0:2, i in 1:3]

@show A
@show f(A)
@show f.(A)

@show A .+ 2 .* f.(A) ./ A
@show broadcast(x-> x+2f(x)/x, A)

