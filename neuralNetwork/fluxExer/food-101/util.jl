using Base.Filesystem
using Base.Iterators
using JSON
using CSV:CSV
using Random

BLACKLIST = ["lasagna/3787908",
             "steak/1340977",
             "bread_pudding/1375816"]

function make_test_pairs(datasetdir)
    p = joinpath(datasetdir,"meta","classes.txt")
    classes = CSV.read(p,header=false)
    classes = Dict([k_name for k_name in enumerate(convert(Array{String,1},classes[:Column1]))])
    json_file = "test.json"
    klass2path = JSON.parsefile(joinpath(datasetdir, "meta", json_file))
    pairs = []
    for (label, klass) in classes
        paths = klass2path[klass]
        for i in 1:length(paths)
            p = paths[i]
            if p in BLACKLIST
                continue
            end
            push!(pairs, (joinpath(datasetdir, "images", p * ".jpg"),label))
        end
    end
    return pairs
end

function make_trainval_pairs(datasetdir;divide_ratio=0.95)
    p = joinpath(datasetdir,"meta","classes.txt")
    classes = CSV.read(p,header=false)
    classes = Dict([k_name for k_name in enumerate(convert(Array{String,1},classes[:Column1]))])
    json_file = "train.json"
    klass2path = JSON.parsefile(joinpath(datasetdir,"meta",json_file))
    train_pairs = []
    val_pairs = []
    for (label, klass) in classes
        paths = klass2path[klass]
        shuffle!(paths)
        for i in shuffle(1:length(paths))
            p = paths[i]
            if p in BLACKLIST
                continue
            end
            if i<= length(paths) * divide_ratio
                push!(train_pairs, (joinpath(datasetdir,"images",p * ".jpg"),label))
            else
                push!(val_pairs, (joinpath(datasetdir,"images",p * ".jpg"),label))
            end
        end
    end
    return train_pairs,val_pairs
end
