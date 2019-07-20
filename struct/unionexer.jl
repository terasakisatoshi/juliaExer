#=
An example of Type unions
=#

mutable struct Point2D
    x::Float64
    y::Float64
end

mutable struct Vector2D
    x::Float64
    y::Float64
end

VecOrPoint2D = Union{Vector2D,Point2D}

import Base.+

function +(u::VecOrPoint2D, v::VecOrPoint2D)
    @show typeof(u),typeof(v)
    if typeof(u) == Vector2D && typeof(v) == Vector2D
        Vector2D(u.x+v.x,u.y+v.y)
    else
        Point2D(u.x+v.x,u.y+v.y)
    end
end

p = Point2D(2,4)
q = Point2D(4,3)
v = Vector2D(3,2)
w = Vector2D(-1,2)

@show typeof(p+q)
@show typeof(p+v)
@show typeof(w+p)
@show typeof(v+w)
