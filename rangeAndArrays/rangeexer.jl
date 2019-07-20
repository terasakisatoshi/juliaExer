# %%

for i in 1:10
    println(i)
end

# %%

a = split("A,B,C,D",",")
@show typeof(a)
@show a

@show [1,2,3]
@show typeof([1,2,3])
@show [1 2 3]
@show typeof([1 2 3])
