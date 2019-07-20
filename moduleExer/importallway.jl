include("ModuleA.jl")

importall MyModule 

mytype = MyType(4)

@show foo(mytype)
@show MyType
#@show bar

@show MyModule.foo(mytype)
@show MyModule.MyType
@show MyModule.bar(2)