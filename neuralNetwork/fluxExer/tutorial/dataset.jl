
#=
The data argument provides a collection of data to train with
(usually a set of inputs x and target outputs y)
For example, here's a dummy data set with only one data point:
=#

x = rand(28*28)
y = rand(10)
data = [(x,y)]
@show data

data = [(x,y),(x,y),(x,y)]
# or equivalently
data = Iterators.repeated((x,y),3)

xs = [rand(784),rand(784),rand(784)]
ys = [rand( 10),rand( 10),rand( 10)]

data = zip(xs,ys)

using Flux: @epochs

@epochs 2 println("Hello")
