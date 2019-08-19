using Makie
using Rotations

function trans(x,y,z)
    urange=-π:0.1π:π
    rs = RotZ.(urange)
    rs = transpose.(rs)
    rs = hcat(rs...)
    [x y z] * rs
end

function torus()
    s=Scene()
    t=4.
    r=1.
    param = -π:0.1π:π
    N=length(param)
    x = t .+ r .* cos.(param)
    y = zeros(size(x))
    z = t .+ r .* sin.(param)
    N=length(x)
    ret=trans(x,y,z)
    ret=reshape(ret,N,3,Int(size(ret)[2]//3))
    ret=permutedims(ret,(1,3,2))
    X=ret[:,:,1]
    Y=ret[:,:,2]
    Z=ret[:,:,3]
    scatter!(s,vcat(X...),vcat(Y...),vcat(Z...))
    #X,Y,Z=hcat(X...),hcat(Y...),hcat(Z...)
    for i in 1:size(X)[1]
        lines!(s,X[i,:],Y[i,:],Z[i,:])
    end

    for j in 1:size(X)[2]
        lines!(s,X[:,j],Y[:,j],Z[:,j])
    end

    s |> display

end

torus()
