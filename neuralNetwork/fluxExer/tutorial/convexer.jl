
#=
Data should be stored in WHCN order. In other words, a 100×100 RGB image would
be a `100×100×3` array, and a batch of 50 would be a `100×100×3×50` array.
=#
using Flux

c=Flux.Conv((3,3), 3=>3)
mp=MeanPool((2,2))
@show size(mp(c(rand(224,224,3,2))))

x = rand(28,28,3,1)
dc = Flux.DepthwiseConv((3,3), 3=>2)
@show size(dc(x))
