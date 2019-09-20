using Makie

function main()
    t = 0:0.01π:6π
    x = cos.(t)
    y = sin.(t)
    z = t/6pi
    s = Scene()
    lines!(s,x,y,z)
    scatter!(s,x,y,z)
    s
end

s=main()
s |> display