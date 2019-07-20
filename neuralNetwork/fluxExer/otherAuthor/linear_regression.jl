#=
Linear Regression using Flux.jl

pkg> add Flux#master
pkg> add Plots

Reference:
https://qiita.com/cometscome_phys/items/f58174c0dad7ecb811ed

=#

using Random
using Flux
using Plots
#using CuArrays

function vandermonde_matrix(xs,maxdim)
    φ(xs,k) = xs.^k
    ret = zeros(Float32,maxdim,length(xs))
    for k in 0:maxdim-1
        ret[k+1,:]=φ(xs,k)
    end
    ret
end

function target_func(x)
    a₀,a₁,b₀ = 3.0,2.0,1.0
    return @. a₀*x + a₁*x^2 + b₀+ 3*cos(20*x)
end

function train(epochs,batchsize)
    k=4
    xs = range(-2,length=100,stop=2)
    X = vandermonde_matrix(xs,k)
    ys = target_func(xs)

    model = Dense(k,1)
    lossfn(x,y)=Flux.mse(model(x),y)
    optimizer = ADAM(params(model))
    for e in 1:epochs
        shuffle_indices=shuffle(1:length(ys))
        loss=0
        for i in 1:floor(Int,length(ys)/batchsize)
            batch_indice=shuffle_indices[(i-1)*batchsize+1:i*batchsize]
            batch_X=X[:,batch_indice]
            batch_ys=ys[batch_indice]
            data=[(batch_X[:,i], batch_ys[i]) for i in 1:batchsize]
            Flux.train!(lossfn, data, optimizer)
            loss=sum(lossfn(batch_X[:,i],batch_ys[i]) for i in 1:batchsize)/batchsize
        end
        if e%100==0
            @show e
            @show loss
        end
    end

    y_predict = [model(X[:,i]).data[1] for i=1:length(ys)]
    plt = plot(xs, [ys,y_predict], marker=:circle,label=["Data","Estimation"])

end


function main()
    train(1000,16)
end

main()
