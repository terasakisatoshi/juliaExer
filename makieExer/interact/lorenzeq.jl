using AbstractPlotting
using AbstractPlotting: textslider
using Colors
using Observables

function main()
    tslider1, _a = textslider(range(-10, stop = 10, length = 101), "a", start=0.)
    tslider2, _b = textslider(range(-10, stop = 10, length = 101), "b", start=0.)
    xs = -π:0.01:π
    ab = lift(tuple, _a,_b)
    pos = lift(ab) do (a, b)
        [Point2f0(x,sin(x)) for x in xs]
    end
    p = lines(pos)

    onany(pos) do pos
             AbstractPlotting.update!(p)
    end
    scene = hbox(p,vbox(tslider1,tslider2))
    RecordEvents(scene, "output")
end



main()
