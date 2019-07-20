using Flux
using CuArrays

bn=BatchNorm(3,ϵ=Float32(1e-7),momentum=Float32(0.1)) |> gpu

@show typeof(bn.β)
@show typeof(bn.γ)
@show typeof(bn.λ)
@show typeof(bn.μ)
@show typeof(bn.σ)
@show typeof(bn.ϵ)
@show typeof(bn.momentum)

data = rand(28,28,3,2) |> gpu
bn(data)
