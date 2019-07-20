using Plots
unicodeplots()

xs = -10:10
p1 = plot(xs,xs)
p2 = plot(xs,xs.^2)
p3 = plot(xs,xs.^3)
p4 = plot(xs,xs.^4)

plot(p1,p2,p3,p4,layout=(2,2),legend=false)
