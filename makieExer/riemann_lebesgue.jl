using Makie
using Makie: textslider
using QuadGK

f(x) = exp(-x^3) # anything you want
g(x, λ) = f(x) * cos(λ * x)

function main()
    λ_slider, λ_obs = textslider(range(1, stop = 10000, step=100), "λ", start = 1)
    x = -1:0.001:1
    plotting = lift(λ_obs) do λ
        Point2f0.(x, g.(x, λ))
    end

    integral = lift(λ_obs) do λ
        res=quadgk(x->g(x,λ),-1,1)[1]
        "$res"
    end

    s1 = lines(x, f.(x))
    s2 = lines(plotting)
    Makie.text!(s2,integral,textsize=0.1,position = Point2f0(1.,1.))
    RecordEvents(
        vbox(s1,hbox(s2, λ_slider), parent=Scene()),
        "output"
    )
end

main()
