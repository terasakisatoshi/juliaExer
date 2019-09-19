#=
Resolution of singularities
=#

using Makie

s = Scene()
θs = -π / 2:0.05:π / 2
r = 2
lines!(zeros(length(θs)), zeros(length(θs)), θs, linewidth = 10)
for θ in θs
    lines!(s, r * [-cos(θ), cos(θ)], r * [-sin(θ), sin(θ)], [θ, θ])
end

x = 0.001:0.001:1.5
y = x.^(3 / 2)
z = y ./ x
lines!(s, x, y, fill(-π / 2, length(x)), linewidth = 5.)
lines!(s, x, y, z, linewidth = 5., color = :blue)

x = 0.001:0.001:1.5
y = -x.^(3 / 2)
z = y ./ x
lines!(s, x, y, fill(-π / 2, length(x)), linewidth = 5.)
lines!(s, x, y, z, linewidth = 5., color = :blue)
