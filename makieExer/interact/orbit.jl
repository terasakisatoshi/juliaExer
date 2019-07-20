using Makie
using Observables

growth(🐇, 🥕) = 🐇 * 🥕 * (1.0 - 🐇)
 function orbitdiagram(growth, r1, r2, n = 500, a = zeros(1000, n); T = 1000)
     rs = range(r1, stop = r2, length = 1000)
     for (j, r) in enumerate(rs)
         x = 0.5
         for _ in 1:T; x = growth(x, r); end
         for i in 1:n
             x = growth(x, r)
             @inbounds a[j, i] = x
         end
     end
     rs, a
 end
 r1 = slider(0:0.001:4, raw = true, camera=campixel!, start = 0.0)
 r2 = slider(0:0.001:4, raw = true, camera=campixel!, start = 4)
 n1 = 500; n2 = 1000; a = zeros(n2, n1)
 positions = Vector{Point2f0}(undef, n1 * n2)
 r1node, r2node = r1[end][:value], r2[end][:value]
 r1r2=lift(tuple, r1node, r2node)
 pos = lift(r1r2) do (r1, r2,)
     global a
     rs, a = orbitdiagram(growth, r1, r2, size(a, 2), a)
     dim = size(a, 2)
     for (i, r) in enumerate(rs)
         positions[((i-1)*dim) + 1 : (i*dim)] .= Point2f0.(r, view(a, i, :))
     end
     positions
 end
 p = scatter(
     pos, markersize = 0.006, color = (:black, 0.2),
     show_axis = false
 )
 onany(pos) do pos
     # faster to give the boundingbox ourselves, since otherwise we'll need to
     # loop over pos!
     #AbstractPlotting.update_limits!(p) # <- would calculate bb
     AbstractPlotting.update_limits!(p, FRect(r1node[], 0, r2node[] - r1node[], 1))
     AbstractPlotting.update!(p)
 end
 scene = hbox(
     p,
     vbox(r1, r2)
 )
 RecordEvents(scene, "output")