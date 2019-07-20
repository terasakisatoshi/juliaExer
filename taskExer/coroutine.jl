#=
Julia sample software pipeline usinn coroutine.
https://docs.julialang.org/en/v1.1/manual/parallel-computing/#Parallel-Computing-1
=#

const loader = Channel{Array{Float64,2}}(5)
const producer = Channel{Array{Float64,2}}(5)


function make_jobs(n)
   while true
       sleep(rand())
       put!(loader, rand(3, 3))
   end
end


function comm()
    println("start")
    while true
        data = take!(loader)
        sleep(rand())
        put!(producer, data)
    end
    println("end")
end


function use_pipeline(n)
    @async make_jobs(n)
    @async comm()
    println("process start")
    for i in 1:n
        @show take!(producer)
    end
end


function sequential(n)
    println("process start")
    for i in 1:n
        #do load something e.g. FileIO
        sleep(rand())
        # do some calculation
        sleep(rand())
        data = rand(3, 3)
        @show data
    end
end


function main()
    n=10
    @time sequential(n)
    @time use_pipeline(n)
end
