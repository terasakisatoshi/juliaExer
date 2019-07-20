using Makie

function main()
    x = range(0, stop=2π, length=40)
    scene = lines(x,sin,color=:blue)
    axis = scene[Axis]
    axis.grid.linecolor=((:green, 1), (:blue, 0.5))
    axis[:names].textcolor = ((:red, 1.0), (:blue, 1.0))
    axis[:names][:axisnames] = ("x", "y=cos(x)")
    scene
end

