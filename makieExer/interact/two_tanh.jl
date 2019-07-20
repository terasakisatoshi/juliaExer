using Makie
using AbstractPlotting: textslider

function target_function(x, y, a, b, c)
        (a*tanh(x) + b*tanh(y) + c)^2
end

function plotsome(z::Array{Float32,2}, a, b, c)
    lspace = range(-1., stop=1., step=0.05)
    z = Float32[target_function(x, y, a, b, c) for x in lspace, y in lspace]
    z
end

function main()
    lspace = range(-1., stop=1., step=0.05)
    N = length(collect(lspace))
    s_a, obs_a = textslider(lspace, "a", start=0.1)
    s_b, obs_b = textslider(lspace, "b", start=0.1)
    s_c, obs_c = textslider(lspace, "c", start=0.1)
    args_n = (obs_a, obs_b, obs_c)
    update_rule = plotsome(zeros(Float32, (N, N)), to_value.(args_n)...)
    positions = lift(plotsome, Node(update_rule), args_n...)

    sur = surface(lspace, lspace, positions)
    axis = sur[Axis]
    axis[:names][:axisnames] = ("x", "y", "(a*tanh(x)+b*tanh(y)+c)^2")

    RecordEvents(
        hbox(
            sur, 
            vbox(s_a, s_b, s_c), 
            parent=Scene()
        ),
        "output"
    )

end

main()