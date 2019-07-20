using PyCall

np = pyimport("numpy")

P = pyimport("numpy.polynomial")
@pydef mutable struct Doubler <: P.Polynomial
    function __init__(self, x=10)
        self.x = x
    end
    my_method(self, arg1::Number) = arg1 + 20
    x2.get(self) = self.x * 2
    function x2.set!(self, new_val)
        self.x = new_val / 2
    end
end

@show Doubler().x2

@pydef mutable struct MyClass
    function __init__(self, x)
        self.x = x
    end
end


#=
py"""
class MyClass():
    def __init__(self, x):
        self.x = x
    def edit(self, v):
        self.x[0] = v
        return self.x
"""
=#

jo = [1 2 3; 4 5 6]
mc = MyClass(jo)
x = PyArray(PyObject(mc.edit(-10)))
@show x
x[2]=-200
@show x
@show mc.x
