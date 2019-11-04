function goma(xs)
    return sum(x for x in xs)
end

function goma(x::T, y::T...) where {T<:Integer}
    return goma((x, y...))
end


@show goma(1, 2, 3)
@show goma((1, 2, 3))
@show goma([1, 2, 3])
