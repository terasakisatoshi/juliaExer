using Plots
using Printf
# %%
#f = (a::Float64,b::Float64,n::Int64) -> n==1 ? (b+a/b)/2 : (f(a,b,n-1) + a/f(a,b,n-1))/2

function f(a::Float64, b::Float64, n::Int64)
    if n == 1
        return (b+a/b)/2
    else
        return (f(a, b, n-1) + a/f(a, b, n-1))/2
    end
end

function nohint_f(a, b, n)
    if n == 1
        return (b+a/b)/2
    else
        return (f(a, b, n-1) + a/f(a, b, n-1))/2
    end
end

g = n -> f(3.0,3.0,n)
nohint_g = n -> nohint_f(3.0,3.0,n)

for n in 1:20
    @printf("n=%d g(n)=%f\n",n, g(n))
end

#%%
anim = @animate for n=1:20
    seq = collect(1:n)
    plot(seq,g.(seq))
end
gif(anim, "anim_fps10.gif", fps = 10)
