using Random
using Distributed


struct SerialIterator
    len::Int
    get_example::Function
    batchsize::Int
    indices::Vector
    function SerialIterator(dataset::Dataset, batchsize::Int; shuffle=true)
        indices=Vector(1:dataset.len)
        if shuffle
            shuffle!(indices)
        end
        _get_example = i -> get_example(dataset, i)
        new(length(dataset), _get_example, batchsize, indices)
    end
end

function Base.iterate(diter::SerialIterator, state=(1, 0))
    idx_start, count = state
    if idx_start + diter.batchsize > diter.len
        return nothing
    else
        indices = diter.indices[idx_start:idx_start+diter.batchsize-1]
        element = diter.get_example.(indices)
        return (element, (idx_start + diter.batchsize, count + 1))
    end
end
