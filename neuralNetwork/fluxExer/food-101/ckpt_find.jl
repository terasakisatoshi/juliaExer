using Base.Filesystem

println(isfile("pretrained.bson"))

println(isfile("hoge"))

include("util.jl")
include("./dataset.jl")
include("./iterator.jl")

using Printf
using Flux
using Statistics
using Flux: onehotbatch, onecold, crossentropy
using Base.Iterators: partition
using Base.Filesystem
using Metalhead:VGG19
using BSON: @load, @save
using CuArrays

function define_model()
    vgg = VGG19()
    model = Chain(vgg.layers[1:end-2],
                  Dense(4096, 101),
                  softmax)
    Flux.testmode!(model, false)
    return model
end

function get_dataset(datasetdir)
    train_paris, val_pairs = make_trainval_pairs(datasetdir)
    train_dataset = Dataset(train_paris)
    val_dataset = Dataset(val_pairs, train=false)
    return train_dataset, val_dataset
end

function main()
    datasetdir = expanduser("~/dataSSD120GB/food-101")
    batchsize = 32
    epochs = 100
    cache_multiplier = 10
    train_dataset, val_dataset = get_dataset(datasetdir)

    model = define_model() |> gpu
    if isfile("checkpoint_weights.bson")
        println("loading checkpoin file")
        @load "checkpoint_weights.bson" checkpoint_weights
        Flux.loadparams!(model, weights)

    loss(x,y)= crossentropy(model(x), y)
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    optimizer = ADAM(params(model))
    for e in 1:epochs
        println("train loop ", e," / ",epochs)
        train_iter = SerialIterator(train_dataset, cache_multiplier * batchsize)
        val_iter = SerialIterator(val_dataset, cache_multiplier * batchsize, shuffle=false)
        for (i, batch) in enumerate(train_iter)
            println("progress ", i," / ", floor(Int, length(train_dataset) / batchsize / cache_multiplier))
            xs = [img for (img, _) in batch]
            ys = [label for (_, label) in batch]
            X = cat(xs..., dims=4)
            Y = onehotbatch(ys, 1:101)
            data = [(X[:,:,:,b] |> gpu, Y[:,b] |> gpu) for b in partition(1: cache_multiplier * batchsize, batchsize)]
            Flux.train!(loss, data, optimizer)
        end

        println("check accuracy")
        total_loss=0
        total_acc=0
        Flux.testmode!(model)
        cnt = 0
        for (i, batch) in enumerate(val_iter)
            println("progress ", i," / ", floor(Int, length(val_dataset) / batchsize / cache_multiplier))
            xs = [img for (img, _) in batch]
            ys = [label for (_, label) in batch]
            X = cat(xs..., dims=4)
            Y = onehotbatch(ys, 1:101)
            data = [(X[:,:,:,b] |> gpu, Y[:,b] |> gpu) for b in partition(1: cache_multiplier * batchsize, batchsize)]
            for (X,Y) in data
                total_loss += loss(X,Y)
                total_acc += accuracy(X,Y)
                cnt+=1
            end
        end
        Flux.testmode!(model, false)
        total_loss /= cnt
        total_acc /= cnt
        @printf("loss = %.3f\n", total_loss)
        @printf("acc = %.3f\n", total_acc)
        checkpoint = model |> cpu
        checkpoint_weights = Tracker.data.(params(checkpoint))
        @save "checkpoint.bson" checkpoint
        @save "checkpoint_weights.bson" checkpoint_weights

    end
    pretrained = model |> cpu
    weights = Tracker.data.(params(pretrained))
    @save "pretrained.bson" pretrained
    @save "weights.bson" weights
    println("Finished to train")
end

main()
