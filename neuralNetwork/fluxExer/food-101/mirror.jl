using Random
using Images, CoordinateTransformations
using ImageView

dic = Dict()
arr = ones(3,2,2)/2.
@show arr
img = colorview(RGB, arr)
dic[1]=img
@show img
chview = channelview(img)
chview[1]=0
@show arr
@show dic[1]
