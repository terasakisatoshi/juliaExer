using PyCall
using SymPy
using REPL

tosub = Dict(
    '1' => '₁',
    '2' => '₂',
    '3' => '₃',
    '4' => '₄',
    '5' => '₅',
    '6' => '₆',
    '7' => '₇',
    '8' => '₈',
    '9' => '₉',
    '0' => '₀',
)

"""
Generate Sym object its names are
x₁,x₂,...
and return them as Sym[]
Example
julia> generate_symbol("x",3)
Sym[x₁, x₂, x₃]
"""
function generate_symbol(v::String, n::Int)
    data::Vector{Sym} = []
    for i = 1:n
        seqdigit = [tosub[c] for c in string(i)]
        v_s = "$v" * join(seqdigit)
        eval(Meta.parse("$(v_s)=Sym(\"$(v_s)\")"))
        push!(data, eval(Meta.parse("$(v_s)")))
    end
    return data
end

"""
This func cant use n more than 9
"""
function _generate_symbol(v, n)
    data = Sym[]
    for i = 1:n
        target = "$(v)\\_$i"
        _sub = REPL.REPLCompletions.completions(target, length(target))[1][1]
        sub = REPL.REPLCompletions.completion_text(_sub)
        v_s = v * sub
        eval(Meta.parse("$(v_s)=Sym(\"$(v_s)\")"))
        push!(data, eval(Meta.parse("$(v_s)")))
    end
    return data
end

n = 5
xs = generate_symbol("x", n)
ys = generate_symbol("y", n)

# Uncomment if you can switch randomized numerical data
#xs, ys=rand(n), rand(n)
#


@vars a b

f(x) = a * x + b
E = 1 / 2 * sum(@. (f(xs) - ys)^2)

function bruteforce()
    ∂E∂a, ∂E∂b = diff(E, a), diff(E, b)
    solution = solve([∂E∂a, ∂E∂b], (a, b))
    solution
end

function theoretical()
    denom = n * sum(xs .^ 2) - sum(xs)^2
    a_num = n * sum(xs .* ys) - sum(xs) * sum(ys)
    â = a_num / denom
    b_num = sum(xs .^ 2) * sum(ys) - sum(xs) * sum(xs .* ys)
    b̂ = b_num / denom
    return Dict(a => â, b => b̂)
end

function uselinsolve1()
    ∂E∂a, ∂E∂b = diff(E, a), diff(E, b)
    solution = linsolve((∂E∂a, ∂E∂b), (a, b))
    return solution
end

function uselinsolve2()
    A = [
        diff(E, a, 2) diff(diff(E, a), b)
        diff(diff(E, b), a) diff(E, b, 2)
    ] .|> simplify
    v = -[diff(E, a)(a => 0, b => 0), diff(E, b)(a => 0, b => 0)]
    solution = linsolve((A, v), a, b)
    return solution
end

py"""
def decompose(r):
    return [[eq for eq in eqs] for eqs in r.args]
"""

r0 = theoretical()
r1 = bruteforce()
r2 = py"decompose"(uselinsolve1())
r3 = py"decompose"(uselinsolve2())


@assert  r0[a] - r1[a] |> simplify == 0
@assert  r0[a] - r2[1] |> simplify == 0
@assert  r0[a] - r3[1] |> simplify == 0

@assert  r0[b] - r1[b] |> simplify == 0
@assert  r0[b] - r2[2] |> simplify == 0
@assert  r0[b] - r3[2] |> simplify == 0

