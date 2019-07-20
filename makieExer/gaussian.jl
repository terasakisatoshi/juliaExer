using Makie
using Distributions: Normal, pdf

function main()
    μ = 0
    σ = 1
    d = Normal(μ, σ)
    xs = -3.:0.01:3.
    ys = pdf.(d, xs)
    lines(xs, ys)
end

function main()
    μ = 0
    σ = 1
    d = Normal(μ, σ)
    xs = -3.:0.01:3.
    pos = map(xs) do x
        Point2f0(x, pdf(d, x))
    end
    lines(pos)
end

main()