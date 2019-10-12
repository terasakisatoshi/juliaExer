using Makie

func(x,y)=2x^2*y/(x^4+y^2)

linrange = LinRange(-1.,1.,500)
z =[func(x,y) for x in linrange, y in linrange]
surface(linrange,linrange,z)
wireframe!(linrange,linrange,zeros(size(z)))
lines!(linrange,linrange.^2,ones(length(linrange)),
       color=:red,linewidth=10
    )
