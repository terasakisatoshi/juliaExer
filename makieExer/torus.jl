using Makie
using Rotations

t=4.
r=1.
param = -π:0.1π:π
x = t .+ r*cos.(param)
y = zeros(size(xs))
z = t .+ r*sin.(param)

X,Y,Z = [],[],[]

for θ in -π:0.1π:π
    @show θ
    r = RotZ(θ)
    v = [x y z] * transpose(r)
    Vx,Vy,Vz = v[:,1],v[:,2],v[:,3]
    push!(X,Vx)
    push!(Y,Vy)
    push!(Z,Vz)
end

s = Scene()

scatter!(s,vcat(X...),vcat(Y...),vcat(Z...))
X,Y,Z=hcat(X...),hcat(Y...),hcat(Z...)
for i in 1:size(X)[1]
    lines!(s,X[i,:],Y[i,:],Z[i,:])
end

s |> display
