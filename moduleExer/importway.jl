include("ModuleA.jl")

import MyModule

mytype = MyModule.MyType(1)

#@show foo(mytype)
#@show MyType
#@show bar

@show MyModule.foo(mytype)
@show MyModule.MyType
@show MyModule.bar(2)

