using Interact
using Blink
using Plots

# specify backend for Plots.jl
pyplot()

plotsui=@manipulate for a in -4:0.05:4
    x= -π:0.01:π
    y=sin.(x.-a)
    Plots.plot(x, y, xlim=(-π, π), ylim=(-1,1))
end

w=Window()
body!(w, plotsui)
