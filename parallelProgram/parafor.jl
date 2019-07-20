N=50
arr=zeros(N)
@parallel for i=1:N 
    arr[i]=i 
end 
println(arr)