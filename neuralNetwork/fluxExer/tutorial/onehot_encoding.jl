using Flux: onehot, onehotbatch, onecold

@show onehot(1,[1,2,3])
@show onehotbatch([1,2], [1,2,3])
@show onecold([0.3,0.2,0.5],[1,2,3])
