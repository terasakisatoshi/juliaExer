using Makie
using Distributions

const d = Normal(0, 1)

𝓝(x) = pdf(d, x)
prior(x, a, b) = (1 - a) * 𝓝(x) + a * 𝓝(x - b)
function main(a, b)
    xs = -5:0.01:5
    ys = [prior(x,a,b) for x in xs]
    lines(xs, ys)
end
