using Flux.Tracker

function simple_differential()
    f(x)=3x^2 + 2x + 1
    f′(x) = Tracker.gradient(f,x)[1]
    @show f′(2)
    f′′(x) = Tracker.gradient(f′,x)[1]
    @show f′′(2)

    f(W,b,x) = W*x+b
    # returns ∂f/∂W ∂f/∂b ∂f/∂x with respect to (W,b,x)=(2,3,4)
    @show Tracker.gradient(f,2,3,4)
end

function differential_with_params()
    W = param(2) # 2.0 (tracked)
    b = param(3) # 3.0 (tracked)

    f(x) = W * x + b

    params = Params([W, b])
    grads = Tracker.gradient(() -> f(4), params)

    @show grads[W] # 4.0
    @show grads[b] # 1.0
end

function main()
    simple_differential()
    differential_with_params()
end 

main()