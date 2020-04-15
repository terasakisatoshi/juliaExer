using BenchmarkTools
using Distributions
import Cubature
import HCubature
import QuadGK

p(x::Float64) = exp(-0.5 * x^2) / √(2π)
p1(x) = p(x[1])
p2(xy) = p(xy[1]) * p(xy[2])
p3(xyz) = p(xyz[1]) * p(xyz[2]) * p(xyz[3])
p4(xyzw) = p(xyzw[1]) * p(xyzw[2]) * p(xyzw[3]) * p(xyzw[4])

function mybench(m::Module)
    @info "start bench $m"
    # 1 次元用のルーチン
    @btime $m.hquadrature(p, -10, 10)[1]
    # 多次元用のルーチンで試す
    @btime $m.hcubature(p1, [-10], [10])[1]
    @btime $m.hcubature(p2, [-10, -10], [10, 10])[1]
    @btime $m.hcubature(p3, [-10, -10, -10], [10, 10, 10])[1]
    @btime $m.hcubature(p4, [-10, -10, -10, -10], [10, 10, 10, 10])[1]
    @info "end bench $m"
end

mybench(Cubature)
mybench(HCubature)
@info "Appendix QuadGK"
# one-dimensional numerical integration
@btime QuadGK.quadgk(p, -10, 10)[1]
