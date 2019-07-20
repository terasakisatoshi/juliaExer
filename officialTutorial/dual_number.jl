# https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/AutoDiff.ipynb
# Dual Number

using InteractiveUtils 
versioninfo()

struct D <: Number 
    f::Tuple{Float64,Float64}
end 

Base.show(io::IO, x::D) = print(io,x.f[1]," + ", x.f[2],"ϵ")

import Base: +, -, *, /, convert, promote_rule
+(x::D, y::D) = D(x.f .+ y.f)
-(x::D, y::D) = D(x.f .- y.f)
*(x::D, y::D) = D((x.f[1] .* y.f[1], x.f[2] * y.f[1] + x.f[1] * y.f[2]))
/(x::D, y::D) = D((x.f[1] / y.f[1], (y.f[1] * x.f[2] - x.f[1] * y.f[2]) / y.f[1]^2))
convert(::Type{D}, x::Real) = D((x,zero(x)))
promote_rule(::Type{D}, ::Type{<:Number}) = D

ϵ = D((0,1))

@show ϵ * ϵ, ϵ^2
@show 1/(1+ϵ)
@show (1+ϵ)^10

function nthroot(x, n=2; t=1, N = 10) 
    for i in 1:N
        t += (x/t^(n-1)-t)/n
    end
    t
end

@show nthroot(2,3), ∛2
@show nthroot(7,12), 7^(1/12)
x=17.0; @show nthroot(x+ϵ, 3), ∛x, 1/x^(2/3)/3

#= output
Julia Version 0.7.0
Commit a4cb80f3ed (2018-08-08 06:46 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin14.5.0)
  CPU: Intel(R) Core(TM) M-5Y51 CPU @ 1.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.0 (ORCJIT, broadwell)
(ϵ * ϵ, ϵ ^ 2) = (0.0 + 0.0ϵ, 0.0 + 0.0ϵ)
1 / (1 + ϵ) = 1.0 + -1.0ϵ
(1 + ϵ) ^ 10 = 1.0 + 10.0ϵ
(nthroot(2, 3), ∛2) = (1.2599210498948732, 1.2599210498948732)
(nthroot(7, 12), 7 ^ (1 / 12)) = (1.1760474285795146, 1.1760474285795146)
(nthroot(x + ϵ, 3), ∛x, (1 / x ^ (2 / 3)) / 3) = (2.571281590658235 + 0.05041728609133794ϵ, 2.571281590658235, 0.05041728609133795)
=#