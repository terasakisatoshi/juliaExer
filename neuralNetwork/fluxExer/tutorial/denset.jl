
relu6(x) = min(max(zero(x),x), eltype(x)(6))
using Flux, CuArrays
m = Dense(10,5) |> gpu
x = rand(10) |> gpu

@show m(x)

m = Chain(
  Dense(28^2, 64),
  BatchNorm(64)) |>gpu

x = rand(28^2,3) |> gpu
@show typeof(x)
@show typeof(m.layers[1].W.data)
@show typeof(BatchNorm.σ)
@show m(x)
