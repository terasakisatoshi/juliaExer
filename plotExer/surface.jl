using Plots

f(x, y) = (1/2pi)*exp(-(x^2+y^2)/2)

function main()
    plotlyjs()
    xs = -5.:0.01:5.
    ys = -1.:0.01:1.
    zs = [f(x, y) for y in ys, x in xs]
    plot(xs, ys, zs, linetype=:surface)
end
