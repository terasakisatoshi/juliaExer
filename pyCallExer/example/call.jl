using PyCall


#=
you can't omit double quote surrounds `path`
i.e.
good:
pyimport("sys")."path"
bad:
pyimport("sys").path
=#

# import python files located in the current directory
pushfirst!(
    PyVector(pyimport("sys")."path"),
    @__DIR__
)


# import sample module
sample=pyimport("sample")
# we can call module under `mymod`
goma = pyimport("mymod.goma")

sample.main()
goma.say9()

