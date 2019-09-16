using Plots
using ImplicitEquations
using ForwardDiff

a, b = 1 / √2, 1 / √2
f(x, y) = x^2 + y^2 - 1
f(xy) = f(xy[1], xy[2])
g = xy -> ForwardDiff.gradient(f, xy)

"""
x' = x-a
y' = y-b
"""
function shift(f::Function, a, b)
    t = [
        1 0 a;
        0 1 b;
        0 0 1
    ]
    function tf(xy)
        x, y = xy
        tx, ty, tz = t * [x, y, 1]
        txy = [tx, ty]
        return f(txy)
    end
    tf(x, y) = tf([x, y])
    return tf
end

"""
x'' = x'
y'' = f_x(a,b)*x' + f_y(a,b)*y'
"""
function cvt(f, a, b)
    fx, fy = g([a, b])
    t = [
        1 0 0;
        -fx / fy 1 / fy 0;
        0 0 1
    ]
    t = t / fy
    function tf(xy)
        x, y = xy
        tx, ty, tz = t * [x, y, 1]
        txy = [tx, ty]
        return f(txy)
    end
    tf(x, y) = tf([x, y])
    return tf
end

plot(aspect_ratio = :equal)
plot!(Eq(f, 0))
sf = shift(f, a, b)
plot!(Eq(sf, 0))
plot!(Eq(cvt(sf, a, b), 0))
