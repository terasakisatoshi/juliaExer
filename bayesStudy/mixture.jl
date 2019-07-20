using Distributions: Normal, MixtureModel, pdf
using Makie

function main()
    d = Normal(0, 1)
    a=0.5
    b=3.0
    N(x) = pdf(d, x)
    p(x) = (1 - a) * N(x) + a *N(x - b)
    mixmodel = MixtureModel(
        Normal[
            Normal(0., 1.0),
            Normal(b, 1.0)
        ], 
        [1-a, a]
    )
    xs = -5:0.01:5
    s=lines(xs, p.(xs))
    lines!(s, xs, pdf.(mixmodel, xs))
end
