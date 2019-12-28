using DifferentialEquations
function f(du, u, p, t)
    du[1] = u[2]
    du[2] = -p
end

function condition(u, t, integrator)
    u[1]
end

function affect!(integrator)
    integrator.u[2] = -integrator.u[2]
    integrator.u[2] *= 0.86
end
cb = ContinuousCallback(condition, affect!)
tspan = (0.0, 40.0)
p = 9.8
u0 = [100.0, -6]
prob = ODEProblem(f, u0, tspan, p)
ball_sol = solve(prob, Tsit5(), callback = cb)

using Luxor
demomovie = Movie(400, 400, "bouncing ball")
function frame(scene::Scene, framenumber)
    ballradius = scene.movie.width / 8
    ground = scene.movie.height / 2 * 0.95
    height = scene.movie.height / 2
    i = rescale(framenumber, 1, scene.framerange.stop, tspan[1], tspan[end])
    yval = clamp(ball_sol(i)[1], 0.0, height)
    ypos = rescale(yval, 0, height / 2, ground - ballradius, -height / 2)
    xpos = rescale(
        framenumber,
        1,
        scene.framerange.stop,
        -scene.movie.width / 2 + 100,
        scene.movie.width / 2 - 100,
    )
    sethue("orange")
    circle(Point(xpos, ypos), ballradius, :fill)
    sethue("black")
    setline(5)
    rule(Point(0, ground))
end

destination = "simple-bouncing-ball.gif"

animate(
    demomovie,
    [
     Scene(demomovie, (s, f) -> background("white"), 1:100),
     Scene(demomovie, frame, 1:100),
    ],
    creategif = true,
    pathname = destination,
)

include("viewer.jl"); Viewer(destination)
