using Distributions
using Plots
using LinearAlgebra

k(x,y; θ₁=1., θ₂=1.) = θ₁ * exp(-(x-y)^2 / θ₂)

N= 10
xs = range(1,stop=4,length=N)
μ=zeros(N)
Σ = Symmetric(k.(xs, xs',θ₁=0.5,θ₂=2.))
d=MvNormal(μ, Σ)
ys=rand(d)
plot(xs,ys)
