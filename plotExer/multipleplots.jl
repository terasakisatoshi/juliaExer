using Plots
x = 1:10
ys=reshape(1:10*5,10,5)
p=plot(x,ys)
plot!(x,sin.(collect(x)))
plot!(p,x,cos.(collect(x)))
