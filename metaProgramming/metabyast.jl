function new_struct(fields::Vector{Tuple{String,DataType}})
    name = "A" * string(hash(fields), base = 16)
    c = Expr(
        :block,
        Expr(
            :struct,
            false,
            Symbol(name),
            Expr(:block, [Expr(:(::), Symbol(f[1]), f[2]) for f in fields]...),
        ),
        Symbol(name),
    )
    eval(c)
end

myS = new_struct([("a", Int), ("b", String), ("c", Int)])
dump(myS)

code = Expr(
    :block,
    Expr(
        :struct,
        false,
        Symbol("Goma"),
        Expr(:block, Expr(:(::), Symbol("x"), Int), Expr(:(::), Symbol("y"), Int)),
    ),
    Symbol("Goma"),
)
Goma = eval(code)
println(fieldnames(Goma))
println(Goma(1, 2))
