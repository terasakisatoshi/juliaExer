using SymPy

@vars x y a b c
ex=5x+4y+3a+2b+c

println(ex)
println(free_symbols((x,y,a,b,c)))
println(ex(PI,0,0,0,0))
println(ex(0,PI,0,0,0))
println(ex(0,0,PI,0,0))
println(ex(0,0,0,PI,0))
println(ex(0,0,0,0,PI))
