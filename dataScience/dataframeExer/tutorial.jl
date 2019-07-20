# Introduction to DataFrames
# https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia-DataFrames/01_constructors.ipynb
# Let's get started by loading the DataFrames package

using InteractiveUtils
import DataFrames: DataFrame
import Random: randstring

versioninfo()

#= Constructors 
In this section, you'll see many ways to create a DataFrame using
the DataFrame() constructor.
=#
df = DataFrame(A=1:3, B=rand(3), C=randstring.([3,3,3]))
@show df
#=
df = 3×3 DataFrame
│ Row │ A │ B        │ C   │
├─────┼───┼──────────┼─────┤
│ 1   │ 1 │ 0.643894 │ wpd │
│ 2   │ 2 │ 0.611762 │ 4He │
│ 3   │ 3 │ 0.665899 │ u1Y │
=#

# We can create a DataFrame from a dictionary, in which case 

dict = Dict("C"=> [1,2], "B"=>[true,false], "A"=>['a','b'])
df = DataFrame(dict)
@show df

#=
Rather than explicitly creating a dictionary first, as above, 
we coult pass DataFrame arguments with the syntax of dictionary
key-value pairs.
=#

df = DataFrame(:A => [1,2], :B => [true,false], :C => ['a','b'])
@show df

#create a DataFrame from a matrix
@show DataFrame(transpose([1 2 3]))
df = DataFrame([1 2 3; 4 5 6; 7 8 9])
@show df 
m = convert(Matrix, df)
@show m
# pass a second argument to give the columns names
@show DataFrame([1:3,4:6,7:9], [:A,:B,:C])

