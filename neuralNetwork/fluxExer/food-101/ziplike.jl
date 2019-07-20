using Base.Threads
using Distributed

include("util.jl")
include("./dataset.jl")
include("./iterator.jl")

function get_dataset(datasetdir)
    train_paris, val_pairs = make_trainval_pairs(datasetdir)
    train_dataset = Dataset(train_paris)
    val_dataset = Dataset(val_pairs)
    return train_dataset, val_dataset
end


function cachecheck()
    datasetdir = expanduser("~/dataSSD120GB/food-101")
    train_dataset, val_dataset = get_dataset(datasetdir)
    println("Hello")
    batchsize=32
    mag = 10
     val_iter = SerialIterator(val_dataset,batchsize*mag,shuffle=false)
    @time for batch in val_iter
        break
    end

     val_iter = SerialIterator(val_dataset,batchsize*mag,shuffle=false)
    @time for batch in val_iter
        break
    end

     val_iter = SerialIterator(val_dataset,batchsize*mag,shuffle=false)
    @time for batch in val_iter
        break
    end
    println(typeof(val_dataset.data[1]))
    println(typeof(val_iter.get_example))
    #println(sort([k for k in keys(val_dataset.image_cache)]))
end

#cachecheck()
dic=Dict{Int,Any}()
datasetdir = expanduser("~/dataSSD120GB/food-101")
train_dataset, val_dataset = get_dataset(datasetdir)
for (i, (f,l)) in enumerate(val_dataset.data[1:100])
    dic[i]=load(f)
end
