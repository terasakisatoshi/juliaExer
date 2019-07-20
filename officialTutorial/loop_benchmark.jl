#=
https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/04.%20Loops.ipynb
=#

#=
let's use for loops to create some addition tables,
where the value of every entry is the sum of its row and column indices.
=#

function create_table1(m,n)
    A = fill(0, (m, n))
    for i in 1:m 
        for j in 1:n 
            A[i,j] = i+j 
        end
    end
    return A
end

#=
Here is some syntactic sugar for the same nested `for` loop
=#

function create_table2(m,n)
    B = fill(0, (m, n))
    for i in 1:m, j in 1:n 
        B[i,j] = i+j 
    end
    return B
end

#=
The more "Julia" way to create this addition table would have been
with an array comprehension.
=#

function create_table3(m,n)
    C = [i+j for i in 1:m, j in 1:n]
    return C
end

@show create_table1(4,5)
@show create_table2(4,5)
@show create_table3(4,5)

using InteractiveUtils
versioninfo()

using BenchmarkTools
m,n=1000,1000
@btime create_table1(m,n)
@btime create_table2(m,n)
@btime create_table3(m,n)