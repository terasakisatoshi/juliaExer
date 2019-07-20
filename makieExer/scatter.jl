# taken from tutorial of Makie.jl

using Makie

function sactter_withcolors()
    x = [1, 2, 3, 4]
    y = [4, 3, 2, 1]
    colors = [0,2,4,6]
    scene = scatter(x, y, color = colors)
end

function scatter_increase_its_size()
    x = [1, 2, 3, 4]
    y = [4, 3, 2, 1]
    markersize = [1,3,2,4] ./ 10
    scene = scatter(x, y, markersize = markersize)
end

function scatter_mixin()
    x = [1, 2, 3, 4]
    y = [4, 3, 2, 1]
    markersize = [1,3,2,4] ./ 10
    colors = [0,2,4,6]
    scatter(x, y, color=colors, markersize=markersize)
end

function main()
    scatter_mixin()
end