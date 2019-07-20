using Base.Iterators: repeated, partition


for i in partition(1:60000,32)
    @show typeof(i)
end
