arr = [1,2,3,4,5]
@show arr
another = arr
@show another
another[1]=-1
@show another,arr
arr[end]=-100
@show another,arr

arr = [1,2,3,4,5]
@show arr
cparr = copy(arr)
@show cparr
cparr[1]=-1
@show cparr,arr
arr[end]=-100
@show cparr,arr

function copyarr(n)
    s = zeros(n,n)
    for i in 1:n
        sample=copy(ones(n,n))
        s+=(-1)^i*sample
    end
    s
end

ret=copyarr(11)

function copyarr2(n)
    s = zeros(n,n)
    sample = similar(s)
    for i in 1:n
        copy!(sample,ones(n,n))
        s+=(-1)^i*sample
    end
    s
end

ret2=copyarr2(11)

@assert ret2==ret

using BenchmarkTools
copyarr(303)
copyarr2(303)

p = 1+1==2 ? "seyana" : "seyaroka"
print(p)
