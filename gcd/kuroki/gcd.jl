using BenchmarkTools

function calc_pi_by_gcd(N)
    s = 0
    for a in -N÷2:N÷2-1
        for b in -N÷2:N÷2-1
            s += ifelse(gcd(a,b)==1, 1, 0)
        end
        s
    end
    sqrt(6N^2/s)
end

@time calc_pi_by_gcd(20000)

function calc_pi_by_gcd_parallel(N)
    c = @parallel (+) for a in -N÷2:N÷2-1
        s = 0
        for b in -N÷2:N÷2-1
            s += ifelse(gcd(a,b)==1, 1, 0)
        end
        s
    end
    sqrt(6N^2/c)
end

addprocs(39)

@time calc_pi_by_gcd_parallel(20000*5)