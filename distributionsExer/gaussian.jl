using Plots
using LinearAlgebra

σ11 = σ22 = 1.0
σ12 = σ21 = -0.7

Σ = [
    σ11 σ12
    σ21 σ22
]

L = cholesky(Σ).L
cL = size(L, 2)

boxmuller(r1, r2) = √(-2 * log(r1)) * sin(2π * r2)
univariate(n...) = boxmuller.(rand(n...), rand(n...))

function multivariate(n)
    x = univariate(cL, n)
    return L * x
end

xy = multivariate(100)
scatter(xy[1, :], xy[2, :])
