tup = (1,2,3)
@show typeof(tup)

@show tup[1]
for t in tup
    println(t)
end

#=
tup[1]=9
ERROR: LoadError: MethodError: no method matching setindex!(::Tuple{Int64,Int64,Int64}, ::Int64, ::Int64)
=#

namedtup = (integer = 3, realnumber=3.14,complexnumber=2+3im)
@show namedtup.integer
@show namedtup.realnumber
@show namedtup.complexnumber
@show namedtup[:integer]
@show namedtup[:realnumber]
@show namedtup[:complexnumber]

for k in keys(namedtup)
    println(k)
end

for value in values(namedtup)
    println(value)
end

for value in namedtup
    println(value)
end

for (k,v) in pairs(namedtup)
    println(k,v)
end
