using Flux
using BSON: @load, @save
using CuArrays

function define_model()
    model = Chain(Dense(10,5,relu),
                  Dense(5,2),
                  softmax)
    return model
end

function save_model()
    model = define_model() |> gpu
    weights = Tracker.data.(params(model))
    @show weights
    @save "mymodel.bson" weights
end

function load_model()
    @load "mymodel.bson" weights
    @show weights
    model = define_model()
    Flux.loadparams!(model, weights)
end

function checkpoint_save()
    model = define_model()
    eval_callback = Flux.throttle(30) do
        @save "model-checkpoint.bson" model
    end
end

function main()
    save_model()
    load_model()
    checkpoint_save()
end
main()
