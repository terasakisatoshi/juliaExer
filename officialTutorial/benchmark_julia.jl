using InteractiveUtils
using BenchmarkTools
using PyCall

versioninfo()

a = rand(10^7) # 1D vector of random numbers, uniform on [0,1)

function mysum(arr)
    s = 0.0
    for a in arr 
        s+=a 
    end
    s
end

function mysum_simd(arr)   
    s = 0.0
    @simd for a in arr
        s += a
    end
    s
end

j_bench=@benchmark sum($a)
println("Julia embedded sum: Fastest time was $(minimum(j_bench.times) / 1e6) msec")

npsum=pyimport("numpy")["sum"]
np_bench=@benchmark npsum($a)
println("np.sum: Fastest time was $(minimum(np_bench.times) / 1e6) msec")

j_bench_hand = @benchmark mysum($a)
println("mysum: Fastest time was $(minimum(j_bench_hand.times)/1e6) msec")

elapsed=@elapsed mysum(a)
@show elapsed

elapsed=@elapsed mysum_simd(a)
@show elapsed

# このコードは動かない・・・
#j_bench_hand_simd @benchmark $(mysum_simd(a))
#println("mysum_simd: Fastest time was $(minimum(j_bench_hand_simd.times)/1e6) msec")

#= output
Julia Version 0.7.0
Commit a4cb80f3ed (2018-08-08 06:46 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin14.5.0)
  CPU: Intel(R) Core(TM) M-5Y51 CPU @ 1.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.0 (ORCJIT, broadwell)
Julia embedded sum: Fastest time was 5.339243 msec
np.sum: Fastest time was 5.530426 msec
mysum: Fastest time was 11.793079 msec
elapsed = 0.025699647
elapsed = 0.026391872
=#