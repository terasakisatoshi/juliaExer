"""
usage:
$ julia -p auto -L buffon.jl
$ buffon(convert(Int,1e9))
$ buffon_parallel(convert(Int,1e9))
"""

using BenchmarkTools

function buffon(n_trial)
    hit_counter = zero(Bool)
    for i in 1:n_trial
        position = rand()
        φ = (rand() * π) - π / 2
        x_right = position + cos(φ) / 2
        x_left = position - cos(φ) / 2
        is_hit = (x_right >= 1 || x_left <= 0) ? 1 : 0
        hit_counter += is_hit
    end
    approx_π = n_trial/hit_counter * 2
end

using Distributed

function buffon_parallel(n_trial)
    hit_counter = @distributed (+) for i in 1:n_trial
        position = rand()
        φ = (rand() * π) - π / 2
        x_right = position + cos(φ) / 2
        x_left = position - cos(φ) / 2
        (x_right >= 1 || x_left <= 0) ? 1 : 0
    end
    approx_π = n_trial/hit_counter * 2
end

function main()
    @benchmark buffon(convert(Int,1e9))
    @benchmark buffon_parallel(convert(Int,1e9))
end

#main()
