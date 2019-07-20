using Makie

function plot_curve()
    x = range(0, stop = 2π, length = 120)
    f(x) = sin.(x)
    y = f(x)
    scene = lines(x, y, color = :blue)
end

function plot_multiple()
    x = range(0, stop = 2π, length = 120)
    f1(x) = sin.(x)
    f2(x) = cos.(x)
    scene = lines(x, f2, color = :blue)
    lines!(scene, x, f1, color = :red, markersize = 0.1)
end

function plot_3dim()
    t = range(0,stop=2π,length=120)
    x = cos.(t)
    y = sin.(t)
    z = t
    lines(x,y,z)
end

function main()
    plot_3dim()
end