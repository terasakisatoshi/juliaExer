using Makie

function main()
    s = Scene()
    x = -10:0.01:-0.1
    lines!(s, x, 1 ./ x)
    x = 0.1:0.01:10
    lines!(s, x, 1 ./ x)
end

main()
