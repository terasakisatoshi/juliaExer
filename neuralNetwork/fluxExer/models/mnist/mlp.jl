#=
MNIST sample
Taken from model zoo of Julia and modified.
https://github.com/FluxML/model-zoo/blob/master/vision/mnist/mlp.jl
=#

using Printf

using Flux, Flux.Data.MNIST, Statistics
using Flux: onehotbatch, onecold, crossentropy, @epochs
using Base.Iterators: partition
using BSON: @load, @save
using CuArrays
using Random

function prepare_dataset(;train=true)
    train_or_test = ifelse(train,:train,:test)
    imgs = MNIST.images(train_or_test)
    X = hcat(float.(vec.(imgs))...)
    labels = MNIST.labels(train_or_test)
    Y = onehotbatch(labels,0:9)
    return X, Y
end


function define_model(;hidden)
    mlp = Chain(Dense(28^2,hidden,relu),
                Dense(hidden,hidden,relu),
                Dense(hidden,10),
                softmax)
    return mlp
end

function split_dataset_random(X, Y)
    divide_ratio=0.9
    shuffled_indices = shuffle(1:size(Y)[2])
    divide_idx = round(Int,0.9*length(shuffled_indices))
    train_indices = shuffled_indices[1:divide_idx]
    val_indices = shuffled_indices[divide_idx:end]
    train_X = X[:,train_indices]
    train_Y = Y[:,train_indices]
    val_X = X[:,val_indices]
    val_Y = Y[:,val_indices]
    return train_X, train_Y, val_X, val_Y
end

function train()
    println("Start to train")
    epochs = 10
    X, Y = prepare_dataset(train=true)
    train_X, train_Y, val_X,val_Y = split_dataset_random(X, Y)
    model = define_model(hidden=100) |> gpu
    loss(x,y)= crossentropy(model(x),y)
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    batchsize = 64
    train_dataset = gpu.([(train_X[:,batch] ,train_Y[:,batch]) for batch in partition(1:size(train_Y)[2],batchsize)])
    val_dataset = gpu.([(val_X[:,batch] ,val_Y[:,batch]) for batch in partition(1:size(val_Y)[2],batchsize)])

    callback_count = 0
    eval_callback = function callback()
        callback_count += 1
        if callback_count == length(train_dataset)
            println("action for each epoch")
            total_loss = 0
            total_acc = 0
            for (vx, vy) in val_dataset
                total_loss += loss(vx, vy)
                total_acc += accuracy(vx, vy)
            end
            total_loss /= length(val_dataset)
            total_acc /= length(val_dataset)
            @show total_loss, total_acc
            callback_count = 0
            pretrained = model |> cpu
            @save "pretrained.bson" pretrained
            callback_count = 0
        end
        if callback_count % 50 == 0
            progress = callback_count / length(train_dataset)
           @printf("%.3f\n", progress)
        end
    end
    optimizer = ADAM(params(model))

    @epochs epochs Flux.train!(loss, train_dataset, optimizer, cb = eval_callback)

    pretrained = model |> cpu
    weights = Tracker.data.(params(pretrained))
    @save "pretrained.bson" pretrained
    @save "weights.bson" weights
    println("Finished to train")
end

function predict()
    println("Start to evaluate testset")
    println("loading pretrained model")
    @load "pretrained.bson" pretrained
    model = pretrained |> gpu
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    println("prepare dataset")
    X, Y = prepare_dataset(train=false)
    X = X |> gpu
    Y = Y |> gpu
    @show accuracy(X, Y)
    println("Done")
end

function predict2()
    println("Start to evaluate testset")
    println("loading pretrained model")
    @load "weights.bson" weights
    model = define_model(hidden=100)
    Flux.loadparams!(model, weights)
    model = model |> gpu
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    println("prepare dataset")
    X, Y = prepare_dataset(train=false)
    X = X |> gpu
    Y = Y |> gpu
    @show accuracy(X, Y)
    println("Done")
end

function main()
    train()
    predict()
    predict2()
end

main()
