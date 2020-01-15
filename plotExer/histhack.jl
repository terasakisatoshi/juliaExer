using Plots

function calc_midpoints(edges::AbstractVector)::Vector{Float64}
    return Float64[0.5 * (edges[i] + edges[i+1]) for i ∈ 1:length(edges)-1]
end

function bin_data(data::AbstractVector, bins::Integer)
    low, high = extrema(data)
    edges = collect(range(low, stop = high, length = bins + 1))
    midpoints = calc_midpoints(edges)
    buckets = Int[max(2, min(searchsortedfirst(edges, x), length(edges))) - 1 for x ∈ data]
    counts = zeros(Int, length(midpoints))
    for b in buckets
        counts[b] += 1
    end
    return edges, midpoints, buckets, counts
end

rectangle(x, y, w, h) = Shape(x .+ [0, w, w, 0], y .+ [0, 0, h, h])

function myhistogram(data; bins = 10, norm = true, alpha = 0.5)
    edges, midpoints, buckets, _counts = bin_data(data, bins)
    if norm
        tot = length(data)
        counts = _counts ./ tot
    else
        counts = _counts
    end
    p = plot()
    for i = 1:length(midpoints)
        emin, emax = edges[i], edges[i+1]
        c = Float64(counts[i])
        r = rectangle(emin, zero(c), emax - emin, c)
        plot!(p, r, legend = false, color = :blue, alpha = alpha)
    end
    p = plot(p)
    return p
end

function main()
    data = randn(1000)
    dmin, dmax = extrema(data)
    bins = 10
    norm = true
    p = myhistogram(data, bins = bins, norm = norm, alpha = 1)
end
