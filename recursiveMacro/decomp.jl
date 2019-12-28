using Plots
using Primes
using Memoize # https://github.com/hymd-research/Memoize.jl.git

@memoize function g(N::T) where {T<:Integer}
    if N == one(T) # meaning N==1
        return one(T)
    else
        fN = sum(e for (_, e) ∈ factor(N).pe)
        ifelse(iseven(fN), 1, -1) + g(N - 1)
    end
end

@time gs = [g(N) for N = 1:1000000]
@assert sum(gs .≥ 0) == 10
scatter(gs)
