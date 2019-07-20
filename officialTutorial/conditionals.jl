#https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/05.%20Conditionals.ipynb

#=
with short-circuit evaluation
We've already seen expressions with the syntax

a & b
for two expressions or values a and b. Julia will evaluate this expression eagerly so that

false & (println("hi"); true)
prints "hi" to stdout before returning false.

On the other hand, when we replace & with &&, as in

a && b
we get short-circuit evaluation. b is only evaluated if a is true, which can help us out if evaluating b is expensive. For example,

false && (println("hi"); true)
returns false without printing "hi".

This means we can use

a && b
to conditionally evaluate b if a is true!
=#

false & (println("hi &"); true)
false && (println("hi &&"); true)


#Similarly, check out the difference between
true | (println("hi |"); true)
true || (println("hi ||"); true)