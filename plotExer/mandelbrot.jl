using Plots

function f(z, C)
    return z * z + C
end

function convergence_judgment(C, inital_z)
    z = inital_z
    i = 0
    while i < 100
        z = f(z, C)
        if abs2(z) > 4
            return i
        end
        i += 1
    end
    return i
end

function generate_grid(N, inital_z)
    grid = Array{UInt8}(undef, N, N)
    points = range(-2, 2, length = N)
    n_pts = length(points)
    Threads.@threads for i in 1:n_pts
        for j in 1:n_pts
            ReC = points[i]
            ImC = points[j]
            C = ComplexF64(ReC, ImC)
            grid[j,i] = convergence_judgment(C, inital_z)
        end
    end
    return grid
end

function main(N)
    inital_z = 0.0
    @time grid = generate_grid(N, inital_z)
    heatmap(1:N, 1:N, grid, aspect_ratio = 1)
end

main(20000)
