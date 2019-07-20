using Makie
using AbstractPlotting: textslider

function main()
    sa, _a = textslider(range(-1.,stop=1.,length=100),"a", start=1.)
    sb, _b = textslider(range(-1.,stop=1.,length=100),"b", start=0.)
    xs = -π:0.01:π
    N = length(xs)
    ab = lift(tuple,_a,_b)
    pos = lift(ab) do (a,b)
        map(LinRange(-2π, 2π, 100)) do x
            Point2f0(x,sin(a*x+b))
        end
    end

    p = lines(pos)

    RecordEvents(
        hbox(p, vbox(sa,sb), parent=Scene()),
        "output"
    )
end

main()