using AbstractPlotting

function main()
    s1 = slider(LinRange(0.01, 1, 100), raw = true, camera = campixel!, start = 0.3)
    s2 = slider(LinRange(-2pi, 2pi, 100), raw = true, camera = campixel!)
    data = lift(s2[end][:value]) do v
         map(LinRange(0, 2pi, 100)) do x
            4f0 .* Point2f0(sin(x) + (sin(x * v) .* 0.1), cos(x) + (cos(x * v) .* 0.1))
        end
    end
    p = scatter(data)
end