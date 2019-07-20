using Interact
using Colors
s=slider(0:0.1:1, label="Slider X:")
display(s)
c=map(x->RGB(x,0.5,0.5),observe(s))
display(c)
print(c)
using Images, ImageView
[c]
