using Distributions
using QuadGK
using Plots
using HCubature

unicodeplots()

function gaussian(x; σ=1, μ=0)
   y = @. exp(-(x-μ)^2/2)/sqrt(2π)/σ
   return y
end

function transform(f)
    function g(t)
        return f(t/(1-t^2))*(1+t^2)/(1-t^2)/(1-t^2)
    end
    return g
end

function integral(f, a, b)
    if a == -Inf && b == Inf
        println("Use inf case")
        g = transform(f)
        return quadgk(g, -1, 1)
    else
        return quadgk(f, a, b)
    end
end

function plotgaussian()
    xs = -3:0.01:3
    ys = gaussian(xs)
    plot(xs, ys)
end

function integraloverinf()
    integral(gaussian, -Inf, Inf)
end

struct Parameter
    a
    b
    Parameter(; a,b)=new(a,b)
end

function p(x; w)
    t -> (1-w.a)*gaussian(t) + a * gaussian(x-w.b)
end

function post_distribution(p, φ, w, X; beta=1.)
    f(w)=x->φ(w)*prod(p(X[i], w=Parameter(a=w[1], b=w[2]))^β for i in 1:length(X))
    res=HCubature(f,[0,-5],[1,5])
end

function main()
x    w = Parameter(0.5, 3.0)
    p(x, w=w)
end


#main() 

