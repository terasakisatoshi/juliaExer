include("util.jl")
include("./dataset.jl")
include("./iterator.jl")

using Printf
using Flux
using Statistics
using Flux: onehotbatch, onecold, crossentropy
using Base.Iterators: partition
using Metalhead:VGG19
using BSON: @load, @save
using CuArrays

function define_model()
    vgg = VGG19()
    Flux.testmode!(vgg.layers, false)
    dims7 = size(vgg.layers[end-1].W)[2]
    model = Chain(vgg.layers[1:end-2],
                  Dense(dims7, 101),
                  softmax)
    println(model)
    return model
end

function get_dataset(datasetdir)
    train_paris, val_pairs = make_trainval_pairs(datasetdir)
    train_dataset = Dataset(train_paris)
    val_dataset = Dataset(val_pairs)
    return train_dataset, val_dataset
end

function train_lazyloader()
    datasetdir = expanduser("~/dataSSD120GB/food-101")
    batchsize = 32
    epochs = 100
    cache_multiplier = 10
    train_dataset, val_dataset = get_dataset(datasetdir)

    model = define_model() |> gpu
    loss(x,y)= crossentropy(model(x), y)
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    optimizer = ADAM(params(model))
    for e in 1:epochs
        println("train loop ", e," / ",epochs)
        train_iter = SerialIterator(train_dataset, cache_multiplier * batchsize)
        val_iter = SerialIterator(val_dataset, cache_multiplier * batchsize)
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
        Flux.testmode!(model, true)
        cnt = 0
        for (i, batch) in enumerate(val_iter)
            println("progress", i," / ", floor(Int, length(val_dataset) / batchsize / cache_multiplier))
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
        @printf("loss = %.3f", total_loss)
        @printf("acc = %.3f", total_acc)
        checkpoint = model |> cpu
        checkpoint_weights = Tracker.data.(params(checkpoint))
        model = model |> gpu
        @save "checkpoint.bson" checkpoint
        @save "checkpoint_weights.bson" checkpoint_weights

    end
    pretrained = model |> cpu
    weights = Tracker.data.(params(pretrained))
    @save "pretrained.bson" pretrained
    @save "weights.bson" weights
    println("Finished to train")
end

function train_strictloader()
    datasetdir = expanduser("~/dataSSD120GB/food-101")
    batchsize = 32
    epochs = 100
    cache_multiplier = 10
    train_dataset, val_dataset = get_dataset(datasetdir)

    model = define_model() |> gpu
    loss(x,y)= crossentropy(model(x), y)
    accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))
    optimizer = ADAM(params(model))
    for e in 1:epochs
        println("train loop ", e," / ",epochs)
        XY = [get_example(train_dataset, i) for i in shuffle(1:length(train_dataset))]
        X = cat([img for (img, _) in XY]..., dims=4)
        Y = onehotbatch([label for (_, label) in XY], 1:101)
        for (i, batch) in enumerate(partition(1: length(train_dataset), batchsize))
            println("progress ", i," / ", floor(Int, length(train_dataset) / batchsize))
            data = [(X[:,:,:,b] |> gpu, Y[:,b] |> gpu)]
            Flux.train!(loss, data, optimizer)
        end

        println("check accuracy")
        total_loss=0
        total_acc=0
        Flux.testmode!(model)
        XY = [get_example(val_dataset, i) for i in 1:length(val_dataset)]
        X = cat([img for (img, _) in XY]..., dims=4)
        Y = onehotbatch([label for (_, label) in XY], 1:101)
        cnt = 0
        for (i, batch) in enumerate(partition(1: length(val_dataset), batchsize))
            println("progress ", i," / ", floor(Int, length(val_dataset) / batchsize))
            X_batch = X[:,:,:,batch] |> gpu
            Y_batch = Y[:,batch] |> gpu
            total_loss += loss(X_batch, Y_batch)
            total_acc += accuracy(X_batch, Y_batch)
            cnt+=1
        end
        Flux.testmode!(model, false)
        total_loss /= cnt
        total_acc /= cnt
        @printf("loss = %.3f", total_loss)
        @printf("acc = %.3f", total_acc)
        checkpoint = model |> cpu
        checkpoint_weights = Tracker.data.(params(checkpoint))
        model = model |> gpu
        @save "checkpoint.bson" checkpoint
        @save "checkpoint_weights.bson" checkpoint_weights

    end
    pretrained = model |> cpu
    weights = Tracker.data.(params(pretrained))
    @save "pretrained.bson" pretrained
    @save "weights.bson" weights
    println("Finished to train")
end

train_lazyloader()
