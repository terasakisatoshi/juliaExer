using Flux

w = ones(Float32,3,3,3,16)
b = zeros(Float32,16)
conv = Conv(w,b)
img = ones((10,10,3,1))
ret=conv(img)
@show size(ret)

@show ret
ls
