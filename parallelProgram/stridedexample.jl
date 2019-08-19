using BenchmarkTools

f(z, C) = z * z + C

function convergence_judgment(C, initial_z)
    z = initial_z
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

generate_grid(xrange, yrange, initial_z) =
    @. convergence_judgment(Complex(xrange', yrange), initial_z)



function main(N)
    @time begin
        initial_z = 0.0
        xrange = yrange = Array{Float64}(range(-2, 2, length = N))
        grid = generate_grid(xrange, yrange, initial_z)
    end
    #heatmap(xrange, yrange, grid, aspect_ratio = 1, size = (500, 500))
end

N=10000
main(N);
