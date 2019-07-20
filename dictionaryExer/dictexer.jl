d = Dict("key"=>"value","integer"=>3)
@show d

@show keys(d)
@show values(d)

for (k,v) in pairs(d)
    println(k,v)
end

@show pop!(d,"integer")
@show(d)
