# https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/AutoDiff.ipynb
# Auto Diff

using InteractiveUtils
versioninfo()

# The example is the Babylonian algorithm, known to man for millenia, to compute sqrt(x)
function Babylonian(x; N = 10)
    t = (1+x)/2
    for i = 2:N # For illustration purposes, 10 iterations suffice.
        t=(t+x/t)/2
    end 
    t # should be square root of x
end

# check that it works
x=2; @show Babylonian(x), √x
@show Babylonian(π), √π # \pi + <tab> , and \sqrt + <tab> 

# and now the derivative, almost by magic
struct D <: Number #D is a function-derivative pair
    f::Tuple{Float64,Float64}# f(x), df/dx(x)
end

import Base: +, -, *, /, convert, promote_rule
+(x::D, y::D) = D(x.f .+ y.f)
-(x::D, y::D) = D(x.f .- y.f)
*(x::D, y::D) = D((x.f[1] .* y.f[1], x.f[2] * y.f[1] + x.f[1] * y.f[2]))
/(x::D, y::D) = D((x.f[1] / y.f[1], (y.f[1] * x.f[2] - x.f[1] * y.f[2]) / y.f[1]^2))

convert(::Type{D}, x::Real) = D((x, zero(x)))
promote_rule(::Type{D}, ::Type{<:Number}) = D

x=2.0; @show Babylonian(D((x,1))),(√x,.5/√x)

square = x-> x * x
x=3.0; @show square(D((x, 1))), x*x, 2x

#= output
Julia Version 0.7.0
Commit a4cb80f3ed (2018-08-08 06:46 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin14.5.0)
  CPU: Intel(R) Core(TM) M-5Y51 CPU @ 1.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.0 (ORCJIT, broadwell)
(Babylonian(x), √x) = (1.414213562373095, 1.4142135623730951)
(Babylonian(π), √π) = (1.7724538509055159, 1.7724538509055159)
(Babylonian(D((x, 1))), (√x, 0.5 / √x)) = (D((1.414213562373095, 0.35355339059327373)), (1.4142135623730951, 0.35355339059327373))
(square(D((x, 1))), x * x, 2x) = (D((9.0, 6.0)), 9.0, 6.0)
=#

