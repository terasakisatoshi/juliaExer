using Plots
using ImplicitEquations
using LaTeXStrings

f(x, y) = x^4 - x^2 * y + y^3
g(u, w) = f(u, u * w)

p1 = plot(Eq(f, 0), title = L"x^4 - x^2y + y^3 = 0")
p2 = plot(Eq(g, 0), title = L"u^3(u - w + w^3) = 0")
plot(
    p1,
    p2,
    xlabel = "x",
    ylabel = "y",
    xlim = [-1, 1],
    ylim = [-1, 1],
    aspect_ratio = :equal
)
