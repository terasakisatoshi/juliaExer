include("ModuleA.jl")

using MyModule 

mytype = MyType(4)

@show foo(mytype)
@show MyType
#@show bar

@show MyModule.foo(mytype)
@show MyModule.MyType
@show MyModule.bar(2)