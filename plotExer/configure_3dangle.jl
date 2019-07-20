using Plots

x = 1:1:10
y = z = rand(10)
p = plot(x, y, [z, z], layout = 2)
plot!(p[1], camera = (20,50))
p