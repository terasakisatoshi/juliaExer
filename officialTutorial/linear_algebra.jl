# Basic Linear algebra
# https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/11.%20Basic%20linear%20algebra.ipynb

A = [1 2 3;
     4 5 6;
     7 8 9]

@show A
@show A' # conjuate transpose
@show transpose(A)

x = fill(1.0, (3,))

@show typeof(A), typeof(x)

@show A * x
@show A' * A
@show A'A #allows us to write this wiout `*`

# Solving linear systems
# The problem `Ax=b` for square A is solved by `\` function

A = [1 3 2;
     3 2 4;
     1 9 3]

b = A*x
@show A\b # expected the value of `x`

