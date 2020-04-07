using LinearAlgebra

A = [
   1 2
   2 1
]

e = eigen(A)
V = e.vectors
@show Diagonal(e.values)
V⁻¹ = inv(V)
@show V⁻¹ * A * V

F = rand(3,5)
s = svd(F)

F |> display
s.U * Diagonal(s.S) * s.Vt |> display
