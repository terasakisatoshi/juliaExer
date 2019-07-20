using Plots

x = -π:0.01:π
ys=hcat(sin.(x), cos.(x),tan.(x),sinh.(x))
plot(x,ys,layout=(4,1))
