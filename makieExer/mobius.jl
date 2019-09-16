using Makie

θs = 0:0.01:π
lines!(zeros(length(θs)), zeros(length(θs)), θs,width=10)
for θ in θs
    lines!([-cos(θ), cos(θ)], [-sin(θ), sin(θ)], [θ, θ])
end
