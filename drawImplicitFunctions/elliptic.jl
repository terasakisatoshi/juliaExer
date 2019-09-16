using Plots
using ImplicitEquations

f(x,y) = y^2 - x^3 + x

p1 = plot(Eq(f,0))

xs = -1:0.01:4
ys = -4:0.01:4
zs = f.(xs',ys)

@show size(zs)
p1 = plot(Eq(f,0))
p2 = plot(xs,ys,zs,st=:surface,camera=(10,30))

lay = @layout [a b]
plot(p1,p2,layout=lay,xlabel="x",ylabel="y")
