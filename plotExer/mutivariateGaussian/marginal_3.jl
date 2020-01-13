using Distributions
using Plots
using QuadGK

Σ₁₁, Σ₁₂, Σ₁₃ = 1.0, 0.5, 0.1
Σ₂₁, Σ₂₂, Σ₂₃ = 0.5, 2.0, 0.2
Σ₃₁, Σ₃₂, Σ₃₃ = 0.1, 0.2, 0.5
μ₁=0
μ₂=-1.0
μ₃=2.0

μ = [
    μ₁
    μ₂
    μ₃
]

Σ = [
    Σ₁₁ Σ₁₂ Σ₁₃
    Σ₂₁ Σ₂₂ Σ₂₃
    Σ₃₁ Σ₃₂ Σ₃₃
]


μ_marginal = [
    μ₁
    μ₂
]

Σ_marginal = [
    Σ₁₁ Σ₁₂
    Σ₂₁ Σ₂₂
]


d = MvNormal(μ, Σ)
data = rand(d,250)

"""
p(x,y) = \\int p(x,y,z) dz
"""
function marginal(d, x, y)
    integral, err = quadgk(
        z->pdf(d,[x,y,z]),
        μ[2] - maximum(abs.(Σ)),
        μ[2] + maximum(abs.(Σ)),
        rtol = 1e-8,
    )
    return integral
end

marginal(y,z)=marginal(d,y,z)
contour(collect(-5:0.1:5), collect(-5:0.1:5), marginal)
scatter!(data[1,:], data[2,:], label="numeric")

# the pdf function p(x,y) should be 𝒩(μ_marginal, Σ_marginal).
d = MvNormal(μ_marginal, Σ_marginal)
data = rand(d,250)
scatter!(data[1,:],data[2,:],label="theoretial")
