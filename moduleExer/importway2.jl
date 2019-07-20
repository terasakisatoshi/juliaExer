include("ModuleA.jl")

import MyModule: foo, MyType
#equivalent to 
import MyModule.foo, MyModule.MyType

mytype = MyType(2)
@show foo(mytype)
@show MyType


@show MyModule.foo(mytype)
@show MyModule.MyType
@show MyModule.bar(2)


