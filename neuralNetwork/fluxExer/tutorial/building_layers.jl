using Flux

function naive_implementation()
    W₁ = param(rand(3,5))
    b₁ = param(rand(3))
    layer₁(x) = W₁ * x .+ b₁

    W₂ = param(rand(2,3))
    b₂ = param(rand(2))
    layer₂(x) = W₂ * x .+ b₂

    model(x) = layer₂(σ.(layer₁(x)))
    @show model(rand(5))
end

struct Affine
    W
    b
end

Affine(in::Integer, out::Integer) = Affine(param(randn(out, in)), param(randn(out)))

# overload call, so that object can be used as a function
(m::Affine)(x) = m.W * x .+ m.b

function struct_implementation()
    aff = Affine(10, 5)
    @show aff(rand(10))
end

function main()
    naive_implementation()
    struct_implementation()
end


main()
