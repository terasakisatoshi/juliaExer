using Colors
using Interact

myslider = slider(0:0.01:1, label="myslider")
cmap=map(x->RGB(x,0.5,0.5), observe(myslider))
map(display,[myslider,cmap])
