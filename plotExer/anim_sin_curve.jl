#%%

using Plots
gr()
# %%
xs=-pi:0.1:pi
anim = @animate for i=1:100
    plot(xs,sin.(i*xs));
end
gif(anim, "anim_fps15.gif", fps = 15)
gif(anim, "anim_fps30.gif", fps = 30)

# %%
@gif for i=1:100
    xs=-pi:0.1:pi
    plot(xs,sin.(i*xs));
end every 10
