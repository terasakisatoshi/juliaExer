#=
- An example of using Luxor.jl
- https://cormullion.github.io/pub/2019-06-23-slackmojif.html
=#

using Luxor

function frame(scene, framenumber)
    background("white")
    juliacircles(framenumber)
    sethue("black")
    fontsize(50)
    text(string(framenumber), halign = :center)
end

simpleanimation = Movie(400, 400, "animation")

destination  = "simple.gif"

animate(
    simpleanimation,
    [Scene(simpleanimation, frame)],
    creategif = true,
    pathname = destination,
)

include("viewer.jl")

Viewer(destination)
