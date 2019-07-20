using Plots

Plots.gr()

x= -π:0.01:π
y1=sin.(x)
y2=cos.(x)
p=plot(
    x,
    hcat(y1,y2),
    title="sin curve",
    label=["sin","cos"],
    lw=3
)

xlabel!(p,"x")
