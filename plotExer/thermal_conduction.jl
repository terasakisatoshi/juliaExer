using Makie

f(x,y) = x^3*y^3

x = range(-1,1, length=400)
y = range(-1,1, length=400)
z = f.(x, y')

surface(x,y,z)
