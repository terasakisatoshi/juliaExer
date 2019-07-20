using Plots

function gaussian(x; μ, σ)
    y= @. exp(-(x-μ)^2/2)/sqrt(2π)/sigma
end

function p(y;x,a,b) 
    return gaussian(y, μ=a*sin(bx), σ=1)
end

function main()
    a=1.
    b=1.
    
    #function body
end