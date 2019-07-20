#=
https://github.com/JuliaPy/SymPy.jl/blob/master/examples/tutorial.md
plot(ex1, ex2, a, b) will plot a parametric plot of the two expressions over the interval [a,b]
=#
using Plots
using SymPy

gr()

@vars x

p1 = plot(
    cos(x), sin(x), 0, 2pi,
    aspect_ratio=1,legend=false
)

p2 = plot(
    sin(2x), cos(3x), 0, 4pi,
    aspect_ratio=1, legend=false
)

plot(p1, p2, layout=(1, 2))
