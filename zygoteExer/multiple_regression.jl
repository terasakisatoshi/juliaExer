using PyCall
using SymPy: @vars, Sym
using SymPy: solve, simplify
using Zygote

dot(x,y) = sum(x .* y)

function generate_vector(v::String, n::Int; start::Int = 1, kwargs::String = "")
    data::Vector{Sym} = []
    for i ∈ start:n
        seqdigit = [c for c in string(i)]
        v_s = "$v" * join(seqdigit)
        eval(Meta.parse("@vars $v_s $kwargs"))
        push!(data, eval(Meta.parse("$(v_s)")))
    end
    return data
end

D = 2 # Dimension of data
N = 4 # Num of data


function generate_matrix(
    v::String,
    row::Int,
    col::Int;
    rstart::Int = 1,
    cstart::Int = 1,
    kwargs::String = "",
)::Matrix{Sym}
    X_ = Vector{Sym}[]
    for n = rstart:row
        xn = "$v$n"
        eval(Meta.parse("xn=generate_vector(\"x$n\", $col, start = $cstart, kwargs=\"$kwargs\")"))
        push!(X_, eval(Meta.parse("xn")))
    end
    Xᵀ = Matrix{Sym}(hcat(X_...))
    X = transpose(Xᵀ)
    X
end

X = generate_matrix("x", N, D, cstart = 0, kwargs = "real=true")
y = generate_vector("y", N, kwargs = "real=true")
w = generate_vector("w", D, start = 0, kwargs = "real=true")

# Numerical
# X = rand(N, D + 1)
# y = rand(N)

X[:, 1] .= 1.0 # set xn0 = 1 for n in 1:N

ŷ(X) = X * w
E(X) = 1 / 2 * (dot(y, y) - 2 * dot(y, ŷ(X)) + dot(ŷ(X), ŷ(X)))

@info "calc-gradient"

∇E = gradient(Params([w])) do
    E(X)
end

py"""
def decompose(r):
    return [[eq for eq in eqs] for eqs in r.args]
"""

@info "solve"
solution = solve(∇E[w], w)
solution = [solution[k] for k in w]
@info "solve-with-norma-equation"
# solve ŵ with normal equation
theoretical = inv(Matrix{Sym}(X' * X)) * X' * y

@info "check is equal"
@assert all(solution .- theoretical .|> simplify .== 0)
@info "done"
