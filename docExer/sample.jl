"Tell whether there are too foo items in the array."
foo(xs::Array) = x

"""
    bar(x[, y])

Compute the Bar index between `x` and `y`.
If `y` is missing, compute the Bar index between
all pairs of columns of `x`.

\$\\frac{x}{y}\$

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
function bar(x,y)
    x+y
end