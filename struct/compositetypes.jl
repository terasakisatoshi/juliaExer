#=
In Julia, as a developer you can define your own types to structure data used in
applications. For Example, if you need to represent points in a three-dimensional
space, you can define a type Point, as follows:
=#

mutable struct Point
    x::Float64
    y::Float64
    z::Float64
end

struct Vector3D
    x::Float64
    y::Float64
    z::Float64
end
