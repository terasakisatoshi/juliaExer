n = 0
while n < 10
    global n; n += 1
    println(n)
end

for n in 1:10
    println(n)
end

for friend in ["Ted", "Robyn", "Barney","Lily","Marshall"]
    println("Hi $friend, it's great to see you!")
end

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
    A = fill(0, (m, n))
    for i in 1:m, j in 1:n 
        A[i,j] = i+j 
    end
    return A
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

using BenchmarkTools
m,n=1000,1000
@btime create_table1(m,n)
@btime create_table2(m,n)
@btime create_table3(m,n)