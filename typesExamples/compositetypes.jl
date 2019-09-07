using BenchmarkTools
using InteractiveUtils

struct MyTypeAny
    x
    y
end

struct MyTypeConcrete
    x::Vector{Int64}
    y::Vector{Float64}
end    

struct MyTypeAbstract
    x::Vector{Integer}
    y::Vector{Real}
end

struct MyTypeParametric{T1<:Integer,T2<:Real}
    x::Vector{T1}
    y::Vector{T2}
end



N=100
@benchmark mt = MyTypeAny(rand(Int64,N), rand(Float64, N))
@benchmark mtc = MyTypeConcrete(rand(Int64,N), rand(Float64, N))
@benchmark mta = MyTypeAbstract(rand(Int64,N), rand(Float64, N))
@benchmark mtp = MyTypeParametric(rand(Int64,N),rand(Float64, N))

