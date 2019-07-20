using CuArrays

A = [1 2
     3 4
     5 6]
x = [1
     2]

@show A*x

A=cu(A)
x=cu(x)

@show A*x

x = rand(10)

x = x |> gpu
@show x,typeof(x)
x = x |> cpu
@show x,typeof(x)
