using Makie
using AbstractPlotting: textslider

λ = 0.1
g(x,t) = exp(-λ*π^2*t)*sin(π*x)

function main()
    t_slider, t_obs = textslider(-1:0.2:1,
                                 "t", start = 0)
    x = 0:0.001:1
    plotting = lift(t_obs) do t
        Point2f0.(x, g.(x, t))
    end

    s1 = lines(plotting)
    RecordEvents(hbox(s1, t_slider, parent = Scene()),
        "output",
    )
end

main()
