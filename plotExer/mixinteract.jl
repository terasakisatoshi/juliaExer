using Interact
using Plots

gr()

x = -π:0.05:π
y = sin.(x)

shift = slider(
0.01:0.1:10,
label="shift"
)

mp=@manipulate for s in shift
    @. y=sin(x - s)
    plot(x,y)
    ylims!(-1,1)
end
