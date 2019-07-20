include("ModuleA.jl")

using MyModule: foo, MyType
#euivalent to 
#using MyModule.foo, MyModule.MyType

mytype = MyType(3)
@show foo(mytype)
@show MyType
#@show bar(2)

@show MyModule.foo(mytype)
@show MyModule.MyType
@show MyModule.bar(2)