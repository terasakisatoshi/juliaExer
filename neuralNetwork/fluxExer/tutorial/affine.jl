using Flux.Tracker


function loss(x, y, func)
    ŷ = func(x)
    sum(@. (y - ŷ)^2)
end

function main()
    x, y = rand(5), rand(2)
    W, b = rand(2,5), rand(2)
    affine(x) = W*x + b
    @show loss(x, y, affine)
    W = param(W)
    b = param(b)
    learning_rate=0.0001
    for i in 1:500
        ∇loss = Tracker.gradient(()->loss(x, y, affine), Params([W, b]))
        Tracker.update!(W,-learning_rate * ∇loss[W])
        Tracker.update!(b,-learning_rate * ∇loss[b])
        @show i, loss(x, y)
    end
end

main()
