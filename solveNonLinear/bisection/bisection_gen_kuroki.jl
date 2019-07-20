#solve eq x=cos(x)
#Reference: http://nbviewer.jupyter.org/gist/genkuroki/ce7f62d10365b9a25c82aad499c886c2

function bisection(f, x₀::T, x₁::T; ε=eps(T), maxiter=10^8) where T<:AbstractFloat
    y₀, y₁ = f(x₀), f(x₁)
    iter = 0
    y₀ == 0 && return x₀, iter
    y₁ == 0 && return x₁, iter
    y₀ * y₁ > 0 && return T(NaN), -1
    for iter in 1:maxiter
        x₂ = (x₀ + x₁)/2
        y₂ = f(x₂)
        y₂ == 0 && return x₂, iter
        if y₀ * y₂ > 0
            x₀, y₀ = x₂, y₂
        else
            x₁, y₁ = x₂, y₂
        end
        abs(x₁ - x₀) < ε && return x₂, iter
    end
    return T(NaN), iter
end

function main()
    f(x)=x-cos(x)
    x₀, x₁ = 0.0, 3.14
    @show α, iter = bisection(f, x₀, x₁)
    @show f(α)
end

main()