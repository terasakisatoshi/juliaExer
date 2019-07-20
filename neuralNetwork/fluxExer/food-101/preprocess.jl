using Random
using Images, CoordinateTransformations
using ImageView
using Base.Iterators: partition
path="/home/terasaki/dataSSD120GB/food-101/images/escargots/3547563.jpg"
img = load(path)

function preprocess(im)
  im = channelview(imresize(im, (224, 224))) .* 255
  im .-= [123.68, 116.779, 103.939]
  #im = permutedims(im, (3, 2, 1))
end

@show size(channelview(img))
img1 = preprocess(img)
img2 = preprocess(img)
img3 = preprocess(img)

@show size(img1)
imageset=[preprocess(img) for _ in 1:20]
concatenated = cat(imageset..., dims=4)
@show size(concatenated[:,:,:,1:3])
a = [concatenated[:,:,:,b] for b in partition(1:20,4)]
@show size(a[1])
