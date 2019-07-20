using Makie

function target_function(a, b; x=π/2)
    return a*sin(b*x) + x/3
end

"""
select mode
mode should be `:wireframe` or `:surface`
"""
function draw_surface(mode)
    N = 100
    lspace = range(-2pi, stop=2pi, length=N)
    z = Float32[target_function(a,b) for a in lspace, b in lspace]
    r = range(0, stop=2pi, length=N)
    scene=eval(mode)(r, r, z)
    axis = scene[Axis]
    axis[:names][:axisnames] = ("a", "b", "a*sin(b*x)+x/3")
    scene
end

function main()
    draw_surface(:wireframe)
end

