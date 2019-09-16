using Makie

s=Scene()
xy1, xz1, xy2, xz2 = -1., -1., 1., 1.
lines!(s,[0.,0.,0.,0.,0.],[xy1,xy1,xy2,xy2,xy1],[xz1,xz2,xz2,xz1,xz1])
b=vec(Point3f0.([0.,0.,0.,0.],[xy1,xy1,xy2,xy2],[xz1,xz2,xz2,xz1]))
u=vec(Point3f0.([0.,0.,0.,0.],[0,xy2-xy1,0.,xy1-xy2],[xz2-xz1,0.,xz1-xz2,0]))
arrows!(s,b,u)

yz1, yx1, yz2, yx2 = -1., -1., 1., 1.
lines!(s,[yx1,yx1,yx2,yx2,yx1],[0.,0.,0.,0.,0.],[yz1,yz2,yz2,yz1,yz1])
b=vec(Point3f0.([yx1,yx2,yx2,yx1],[0.,0.,0.,0.],[yz1,yz1,yz2,yz2]))
u=vec(Point3f0.([yx2-yx1,0,yx1-yx2,0],[0.,0.,0.,0.],[0,yz2-yz1,0,yz1-yz2]))
arrows!(s,b,u)

zx1, zy1, zx2, zy2 = -1., -1., 1., 1.
lines!(s,[zx1,zx1,zx2,zx2,zx1],[zy1,zy2,zy2,zy1,zy1],[0.,0.,0.,0.,0.])
b=vec(Point3f0.([zx1,zx2,zx2,zx1],[zy1,zy1,zy2,zy2],[0.,0.,0.,0.]))
u=vec(Point3f0.([zx2-zx1,0,zx1-zx2,0],[0,zy2-zy1,0,zy1-zy2],[0.,0.,0.,0.]))
arrows!(s,b,u)
