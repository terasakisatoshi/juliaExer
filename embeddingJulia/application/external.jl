import Rotations

function helloexternal()
    println("Hi")
end

function rotateZ(θ::Float64,v::Array{Float64})
    r = Rotations.RotZ(θ)
    return convert(Array{Float64},r*v)
end

xxx = 3

@show rotateZ(pi / 6,Float64[1,0,0])

using BenchmarkTools

@benchmark rotateZ(rand(),rand(3))