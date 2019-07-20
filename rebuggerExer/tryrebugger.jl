using Plots

gr()

xs=-pi:0.01:pi

anim = @animate for i = 1:100
    plot(xs,sin.(0.05i*xs))
end

Plots.gif(anim,"anim_fps15.gif",fps=15)
