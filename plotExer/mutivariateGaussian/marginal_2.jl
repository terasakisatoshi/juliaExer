using Distributions
using Plots

unicodeplots()

Σ₁₁ = 1.5
Σ₂₂ = 3.0
Σ₁₂ = Σ₂₁ = 0.7

μ₁ = 3.0
μ₂ = -1.0

μ = [
    μ₁
    μ₂
]

Σ = [
    Σ₁₁ Σ₁₂
    Σ₂₁ Σ₂₂
]

function g(x, μ, σ)
    σ² = σ^2
    return exp(-0.5 * (x - μ)^2 / σ²) / √(2π * σ²)
end


N = 10000
d = MvNormal(μ, Σ)

data = rand(d, N)
xs, ys = data[1, :], data[2, :]

p1 = plot(size = (300, 300))
histogram!(p1, xs, norm = true)
plot!(p1, x -> g(x, μ₁, √Σ₁₁))

p2 = plot(size = (300, 300))
histogram!(p2, ys, norm = true)
plot!(p2, x -> g(x, μ₂, √Σ₂₂))

plot(p1, p2)
