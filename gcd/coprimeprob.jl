using BenchmarkTools
using Distributed

function calc_pi_by_gcd(N)
    s = 0
    for a in 1:N
        for b in 1:N
            s += ifelse(gcd(a,b)==1, 1, 0)
        end
        s
    end
    println(sqrt(6N^2/s))
end

#@time calc_pi_by_gcd(20000)

function calc_pi_by_gcd_parallel(N)
    """
    Note that @parallel has been renamed into @difrom Julia 1.0
    https://discourse.julialang.org/t/loaderror-parallel/15126
    """
    c = @distributed (+) for a in 1:N
        s = 0
        for b in 1:N
            s += ifelse(gcd(a,b)==1, 1, 0)
        end
        s
    end
    println(sqrt(6N^2/c))
end

addprocs()

#@time calc_pi_by_gcd_parallel(20000)
