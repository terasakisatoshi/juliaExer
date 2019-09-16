using Plots
using ImplicitEquations

f(x, y) = y^2 - x^2 - x^3
g(x, y) = y^2 - x^3
h(x, y) = y^3 - x^2 * y + x^4

plot()
plot!(Eq(f, 0), color=:red)
plot!(Eq(g, 0))
plot!(Eq(h, 0))
