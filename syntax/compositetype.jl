struct Foo 
    bar 
    baz::Int 
    qux::Float64 
end 

foo = Foo("Hello",23,1.5)

@show typeof(foo)
@show fieldnames(foo)
@show foo.bar 
@show foo.baz 
@show foo.qux