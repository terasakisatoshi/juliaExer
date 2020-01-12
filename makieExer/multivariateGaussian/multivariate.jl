using LinearAlgebra
using Makie

μ1 = μ2 = 0.0

𝛍 = [
    μ1
    μ2
]

σ11 = σ22 = 1.0
σ12 = σ21 = 0.0

Σ = [
    σ11 σ12
    σ21 σ22
]

function 𝒩(x1, x2; 𝛍 = 𝛍, Σ = Σ)
    𝐱 = [x1, x2]
    Λ = inv(Σ)
    D = length(𝛍)
    return √(det(Λ)) * exp(-0.5 * (𝐱 .- 𝛍)' * Λ * (𝐱 .- 𝛍)) / √(2π)^D
end

x1min, x1max = -1.0, 1.0
x2min, x2max = -1.0, 1.0
x1 = range(x1min, x1max, length = 50)
x2 = range(x2min, x2max, length = 50)
z = 𝒩.(x1', x2)
wireframe(x1, x2, z, colormap = :Spectral)
