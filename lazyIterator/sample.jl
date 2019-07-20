#=
Iteration in Julia 0.7
In Julia 0.7, the iteration interface is now just one function: `iterate`.
=#

iterable = [1,2,3,4,5]
@show typeof(iterable)

for a in iterable
    @show a
end

# this is equivalent as the expressin using `while` loop:

iter_result = iterate(iterable)
while iter_result !== nothing
    global iter_result
    (element, state) = iter_result
    # body
    @show element state
    iter_result = iterate(iterable, state)
end

struct EveryNthStep
    start::Int
    length::Int
    step::Int
    endpoint::Bool
    EveryNthStep(;start,length,step) = new(start,length,step)
end


function Base.iterate(iter::EveryNthStep, state=(iter.start, 0))
    element, count = state
    @show state
    if element >= iter.length
        return nothing
    end

    return (element, (element + iter.step, count + 1))
end

#function Base.iterate(it::EveryNth, (element, count)=(it.start, 0))
#    return count >= it.length ? nothing : (element, (element + it.n, count + 1))
#end
Base.eltype(iter::EveryNthStep) = Int

for element in EveryNthStep(start=0,length=10,step=2)
    println(element)
end

for element in EveryNthStep(-30, 30, 2)
    println(element)
end
