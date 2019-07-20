using Random
using Images, CoordinateTransformations

#taken from
#https://github.com/FluxML/Metalhead.jl/blob/b3c09e58ffa907ab1ef8946a6f9e45858bea0a93/src/utils.jl#L28
function preprocess(img)
    img = channelview(imresize(img, (224, 224))) .* 255
    img .-= [123.68, 116.779, 103.939]
    img = permutedims(img, (3,2,1))
end

function copyimg(img)
    # to reset index of imageview
    imresize(img,size(img))
end

struct Dataset
    len::Int
    data::Array{Tuple{String,Int64},1}
    augment::Bool
    image_cache::Dict{Int,Array{RGB{Normed{UInt8,8}},2}}
    function Dataset(data; train=true)
        augment=train
        cache = Dict{Int,Array{RGB{Normed{UInt8,8}},2}}()
        new(length(data), data, augment, cache)
    end
end

function get_example(dataset::Dataset, i::Int)
    path, label = dataset.data[i]
    if haskey(dataset.image_cache, i)
        img = dataset.image_cache[i]
    else
        img = load(path)
        dataset.image_cache[i]=img
    end
    img = copyimg(img)
    if dataset.augment
        tfm = LinearMap(RotMatrix(-pi/2 * rand([0,1,2,3])))
        img = warp(img, tfm)
        domirror = rand([true,false])
        if domirror
            img = channelview(copyimg(img))
            newimg = zeros(eltype(img), size(img))
            x_range = size(img)[3]
            for i in 1:x_range
                newimg[:,:,x_range - i + 1] = img[:,:,i]
            end
            img = colorview(RGB, newimg)
        end
    end
    img = preprocess(img)
    return img, label
end

Base.length(dataset::Dataset) = dataset.len
