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
using Images:channelview

function prepare_dataset(;train=true)
    train_or_test = ifelse(train,:train,:test)
    imgs = MNIST.images(train_or_test)
    labels = MNIST.labels(train_or_test)
    Y = onehotbatch(labels,0:9)
    return imgs, Y
end


function define_model(;hidden::Int)
    mlp = Chain(Conv((3,3), 1=>hidden, relu, pad=1, stride=1),
                MaxPool((2,2)),
                x -> reshape(x, :, size(x, 4)),
                Dense(14*14*8,10),
                softmax)
    return mlp
end

function split_dataset_random(X, Y)
    divide_ratio=0.9
    shuffled_indices = shuffle(1:size(Y)[2])
    divide_idx = round(Int,0.9*length(shuffled_indices))
    train_indices = shuffled_indices[1:divide_idx]
    val_indices = shuffled_indices[divide_idx:end]
    train_X = X[train_indices]
    train_Y = Y[:,train_indices]
    val_X = X[val_indices]
    val_Y = Y[:,val_indices]
    return train_X, train_Y, val_X, val_Y
end

function train()
    println("Start to train")
    epochs = 3
    X, Y = prepare_dataset(train=true)
    train_img, train_Y, val_img, val_Y = split_dataset_random(X, Y)
    model = define_model(hidden=8) |> gpu
    loss(x,y)= crossentropy(model(x),y)
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    batchsize = 64
    train_X = [cat(permutedims(float.(train_img[batch]))...,dims=4) for batch in partition(1:length(train_img),batchsize)]
    val_X   = [cat(permutedims(float.(val_img[batch]))...,dims=4) for batch in partition(1:length(val_img),batchsize)]
    train_dataset = gpu.([(train_X[i] ,train_Y[:,batch]) for (i, batch) in enumerate(partition(1:size(train_Y)[2],batchsize))])
    val_dataset = gpu.([(val_X[i] ,val_Y[:,batch]) for (i,batch) in enumerate(partition(1:size(val_Y)[2],batchsize))])
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
    test_img, Y = prepare_dataset(train=false)
    batchsize=64
    test_X = [cat(permutedims(float.(test_img[batch]))...,dims=4) for batch in partition(1:length(test_img),batchsize)]
    test_label = gpu.([Y[:,batch] for (i,batch) in enumerate(partition(1:size(Y)[2],batchsize))])
    total_acc=0
    cnt = 0
    for (x,y) in zip(test_X,test_label)
        total_acc += accuracy(x|> gpu, y|>gpu)
        cnt += 1
    end
    println("acc = $(total_acc/cnt)")
    println("Done")
end

function predict2()
    println("Start to evaluate testset")
    println("loading pretrained model")
    @load "weights.bson" weights
    model = define_model(hidden=8)
    Flux.loadparams!(model, weights)
    model = model |> gpu
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    test_img, Y = prepare_dataset(train=false)
    batchsize=64
    test_X = [cat(permutedims(float.(test_img[batch]))...,dims=4) for batch in partition(1:length(test_img),batchsize)]
    test_label = gpu.([Y[:,batch] for (i,batch) in enumerate(partition(1:size(Y)[2],batchsize))])
    total_acc=0
    cnt = 0
    for (x,y) in zip(test_X,test_label)
        total_acc += accuracy(x|> gpu, y|>gpu)
        cnt += 1
    end
    println("acc = $(total_acc/cnt)")
    println("Done")
end

function main()
    train()
    predict()
    predict2()
end

#main()