function circle_len1(θ; n_pts=1000000)
    xmin, xmax = cos(θ), 1
    ts = sort(rand(n_pts))
    xs = @. (xmax-xmin)/(1. - 0.) * ts + xmin
    ys = @. sqrt(1 - xs * xs)
    d = zero(eltype(xs))
    for i in 1:(length(xs)-1)
        d += sqrt((xs[i+1]-xs[i])^2+(ys[i+1]-ys[i])^2)
    end
    println(d)
    println(θ)
end

function circle_len2(θ; n_pts=1000000)
    xmin, xmax = cos(θ), 1
    t = sort(rand(n_pts))
    x = @. (xmax-xmin)/(1. - 0.) * t + xmin
    y = @. sqrt(1 - x * x)
    ds = @. sqrt((x[2:end] - x[1:end-1])^2+(y[2:end] - y[1:end-1])^2)
    d=sum(ds)
    println(d)
    println(θ)
end

function circle_len3(θ; n_pts=1000000)
    ts = θ * sort(rand(n_pts))
    xs = sin.(ts)
    ys = cos.(ts)
    d = zero(eltype(xs))
    for i in 1:(length(xs)-1)
        d += sqrt((xs[i+1]-xs[i])^2+(ys[i+1]-ys[i])^2)
    end
    println(d)
    println(θ)
end

circle_len3(2π)