

using BenchmarkTools
using LinearAlgebra

function g(x::Array{Float64, 1})
    y = zeros(length(x))
    z = Diagonal(ones(length(x)))
    q = ones(length(x))
    y .= z * x .+ q
end

function g_notyped(x)
    y = similar(x)
    z = I 
    q = ones(eltype(x), length(x))
    y  .= z * x .+ q
end
