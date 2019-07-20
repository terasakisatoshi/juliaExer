#populate array
# %%

# Atom Editorで起動 uber-junoがすでに導入されているとする。
# ここら辺にカーソルを移動
# option + enter を押す。
# 次の`# %%` が出てくるまでの部分まで実行される
println("ここから処理が始まるよ")
arr = [1,2,3]
@show arr

arr = Float64[]
push!(arr,1)
@show arr

arr = Int64[]
push!(arr,1)
@show arr

println("ここで処理が終わるよ")

# %%
@show collect(1:7)
@show size(collect(1:7),1)

arr = Float64[]
sizehint!(arr,6)
@show size(arr)
for i in 1:10
    push!(arr,i)
end

@show arr


# %%

arr = collect(1:10)
@show arr[3:7]

# %%
@show println(Array{Any}(undef,4))
@show fill!(arr,42)

# %% concatenate arrays

a₁ = [-1,-2,-3]
a₂ = [4,5,6]

append!(a₁,a₂)
@show a₁

# you can't do
#append!(a₁,9)

# %%

arr = collect(1:8)
@show arr
p=pop!(arr)
@show p
@show arr

p=popfirst!(arr)
@show p
@show arr
pushfirst!(arr,-1)
@show arr

# %%
# splice

arr = collect(1:8)

@show arr
splice!(arr,3)
@show arr

# %%

#=
Checking wheather an array contains an element
=#
arr = collect(1:8)

@show　4 in arr
@show -1 in arr
@show in(4,arr)
@show in(-1,arr)


#=
julia> import LinearAlgebra:dot

julia> f = x -> dot(x,x); g = x -> sum(x .* x);

julia> arr =collect(1:1000);

julia> @benchmark f(arr)
BenchmarkTools.Trial:
  memory estimate:  16 bytes
  allocs estimate:  1
  --------------
  minimum time:     264.665 ns (0.00% GC)
  median time:      268.938 ns (0.00% GC)
  mean time:        326.445 ns (10.09% GC)
  maximum time:     276.418 μs (99.82% GC)
  --------------
  samples:          10000
  evals/sample:     328

julia> @benchmark g(arr)
BenchmarkTools.Trial:
  memory estimate:  7.95 KiB
  allocs estimate:  2
  --------------
  minimum time:     715.370 ns (0.00% GC)
  median time:      1.134 μs (0.00% GC)
  mean time:        1.772 μs (37.87% GC)
  maximum time:     897.657 μs (99.85% GC)
  --------------
  samples:          10000
  evals/sample:     108

julia> f(arr) == g(arr)

=#
