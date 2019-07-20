struct Point{T}
    x::T 
    y::T 
end 

@show Point{Float64} <: Point
@show Float64 <: Real
@show Point{Float64} <: Point{Real}
@show supertype(Point)

function norm(p::Point{Real})
    sqrt(p.x^2+p.y^2)
end 
