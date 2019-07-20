
counter = 0
struct Point{T<:Real}
      idx::Int
      x::T
      y::T
end


function Point(x::T,y::T) where T<:Real
      global counter
      idx = counter
      counter+=1
      Point{T}(idx, x ,y)
end


p = Point(1.0f0, 3.0f0)
q = Point(1.0, 3.0)

@show 3.0f0

for i in 1:10
      @show Point(-1, 1)
end
