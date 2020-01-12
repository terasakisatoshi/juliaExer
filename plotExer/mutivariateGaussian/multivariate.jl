#=
持橋，大羽 著　「ガウス過程と機械学習」（機械学習プロフェッショナルシリーズ）
多変量ガウス分布のサンプリングのJuliaによる実装
=#

using LinearAlgebra
using Plots
using LaTeXStrings

μ1 = μ2 = 0.0

𝛍 = [
    μ1
    μ2
]

σ11 = σ22 = 1.0
σ12 = σ21 = -0.7

Σ = [
    σ11 σ12
    σ21 σ22
]

function 𝒩(𝐱...; 𝛍 = 𝛍, Σ = Σ)
    Λ = inv(Σ)
    D = length(𝛍)
    return √(det(Λ)) * exp(-0.5 * (𝐱 .- 𝛍)' * Λ * (𝐱 .- 𝛍)) / √(2π)^D
end


x1min, x1max = -4.0, 4.0
x2min, x2max = -4.0, 4.0
x1 = range(x1min, x1max, length = 50)
x2 = range(x2min, x2max, length = 50)
z = 𝒩.(x1', x2)
contour(x1, x2, z)
plot!(
    xlabel = L"x_1",
    ylabel = L"x_2",
    aspect_ratio = 1,
    xlims = [-4.0, 4.0],
    ylims = [-4.0, 4.0],
)
strΣ="\\sigma_{11}=$σ11, \\sigma_{12}=$σ12, \\sigma_{21}=$σ21, \\sigma_{22}=$σ22"
str𝛍="\\mu = [$μ1, $μ2]"
title!(latexstring("\\mathcal{N}(x \\mid \\mu, \\Sigma),\\ $str𝛍 , \\atop $strΣ"))


# Box–Muller transform を用いた方法
L = cholesky(Σ).L
cL = size(L, 2)

boxmuller(r1, r2) = √(-2 * log(r1)) * sin(2π * r2)
univariate(n...) = boxmuller.(rand(n...), rand(n...))

function multivariate(n)
    x = univariate(cL, n) # cL 次元ベクトルを n 個生成する
    return L * x # cL 次元ベクトル を変換して 𝒩(0, Σ) に従うサンプルを生成
end

xy = multivariate(100)
scatter!(xy[1, :], xy[2, :],color=:blue, label="boxmuller")

# Distributions.jl でサンプルを作成
d = MvNormal(𝛍, Σ)
xy = rand(d,100)
scatter!(xy[1,:], xy[2,:],color=:red, label="mvnormal")
