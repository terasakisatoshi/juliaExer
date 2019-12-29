using SymPy: @vars, Sym, solve
using SymPy: simplify
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
N = 3 # Num of data


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

@info "solve"
solution = solve(∇E[w], w)
solution = [solution[k] for k in w]
@info "solve-with-norma-equation"
# solve ŵ with normal equation
theoretical = inv(Matrix{eltype(X)}(X' * X)) * Matrix{eltype(X)}(X') * y


@info "check isequal"
if eltype(theoretical) == Sym
    @assert all(solution .- theoretical .|> simplify .== 0)
else
    solution=Array{Float64}(solution)
    @assert all(isapprox.(solution ,theoretical, atol=1e-6))
end
@info "done"
