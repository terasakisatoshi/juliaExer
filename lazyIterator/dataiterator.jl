#=
DataIterator
=#

import Random.shuffle!

struct Dataset
    len::Int
    data
end

Base.length(dataset::Dataset) = dataset.len

struct SerialIterator
    len::Int
    get_example
    batchsize::Int
    indices::Vector
    function SerialIterator(dataset::Dataset, batchsize; shuffle=true)
        indices=ifelse(shuffle, Vector(1:dataset.len),shuffle!(Vector(1:dataset.len)))
        new(length(dataset), dataset.get_example, batchsize, indices)
    end
end

function Base.iterate(diter::SerialIterator, state=(1, 0))
    idx_start, count = state
    if idx_start + diter.batchsize > diter.len
        return nothing
    else
        indices = diter.indices[idx_start:idx_start+diter.batchsize]
        element = diter.get_example.(indices)
        return (element, (idx_start + diter.batchsize, count + 1))
    end
end

function main()
    len=10000000
    dataset = Dataset(len, i->rand(30,30))
    dataset_iter = SerialIterator(dataset, 32, shuffle=true)
    for i in dataset_iter
        println(i)
    end
end

main()
