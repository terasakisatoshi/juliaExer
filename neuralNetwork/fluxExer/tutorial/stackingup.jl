import Flux: Dense, softmax, σ, Chain

function foldlstyle()
    layers = [Dense(10,5,σ),Dense(5,2),softmax]
    model(x) = foldl((x,m) -> m(x), layers, init=x)
    @show model(rand(10))
end

function chain_style()
    model = Chain(Dense(10,5,σ),
                  Dense(5,2),
                  softmax)
    model(rand(10))
end

function circ_style()
    model = Dense(5,2)∘Dense(10,5,σ)
    model(rand(10))
end

function naive_function_chain()
    chain_func = Chain(x -> x^2, x -> x+1)
    chain_func(5)
end

@show foldlstyle()
@show chain_style()
@show circ_style()
@show naive_function_chain()
