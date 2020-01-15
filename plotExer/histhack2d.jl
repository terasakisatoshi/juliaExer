using Plots

function calc_midpoints(edges::AbstractVector)::Vector{Float64}
    return Float64[0.5 * (edges[i] + edges[i+1]) for i ∈ 1:length(edges)-1]
end

function bin_data1d(data::AbstractVector, bins::Integer)
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

function bin_data2d(data::AbstractMatrix, xbins::Integer, ybins::Integer)
    xmin, ymin = minimum(data, dims = 2)
    xmax, ymax = maximum(data, dims = 2)
    xedges = collect(range(xmin, stop = xmax, length = xbins + 1))
    yedges = collect(range(ymin, stop = ymax, length = ybins + 1))
    xmidpts = calc_midpoints(xedges)
    ymidpts = calc_midpoints(yedges)
    buckets = []
    d, c = size(data)
    for i = 1:c
        x = data[1, i]
        y = data[2, i]
        xb = max(2, min(searchsortedfirst(xedges, x), length(xedges))) - 1
        yb = max(2, min(searchsortedfirst(yedges, y), length(yedges))) - 1
        push!(buckets, (yb, xb))
    end
    counts = zeros(Int, length(ymidpts), length(xmidpts))
    for (yb,xb) in buckets

        counts[yb, xb] += 1
    end
    xedges, yedges, xmidpts, ymidpts, buckets, counts
end

μ=[
-1
-2
]

Σ=[
1.   -0.7
-0.7 1.
]

using Distributions
d=MvNormal(μ,Σ)
xydata=rand(d,5000)

scatter(xydata[1,:],xydata[2,:])
xedges, yedges, xmidpts, ymidpts, buckets, counts = bin_data2d(xydata, 30, 10)
r, c = size(counts)
scatter3d!(xmidpts, ymidpts, counts)
plot!(xlabel="x",ylabel="y")
