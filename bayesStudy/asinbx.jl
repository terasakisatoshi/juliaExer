using Makie
using AbstractPlotting: textslider

function target_func(a,b,x)
    (x/3-a*sin(b*x))^2
end

function main()
    s_x, obs_x = textslider(-π/2. :0.01:π/2., "x", start=0.5)
    alspace = range(-1, stop=1, length=501)
    blspace = range(-π/2, stop=π/2, length=501)
    function update!(z::Array{Float32, 2}, x)
        z = Float32[target_func(a,b,x)
                        for a in alspace, b in blspace]
        @show minimum(z)
        @show argmax(z)
        @show sum(z.-minimum(z).≈0)
        z
    end

    args_n = (obs_x,)
    pos = lift(update!, Node(zeros(Float32, (length(alspace),length(blspace)))), args_n...)
    sur = surface(alspace, blspace, pos)
    axis = sur[Axis]
    axis[:names][:axisnames] = ("a", "b", "a sin(bx)")

    RecordEvents(
        hbox(
            sur,
            vbox(s_x),
            parent=Scene()
        ),
        "output"
    )
end
