using Base.Filesystem
using Glob

@show pwd()

@show readdir(pwd())
@show @__FILE__
@show @__DIR__
@show @__LINE__

@show abspath("./fileio.jl")
@show abspath("../")

@show expanduser("~/work")
@show joinpath(expanduser("~/work"),"juliaLang","fileIO","fileio.jl")
jpath=joinpath(expanduser("~/work"),"juliaLang","fileIO","fileio.jl")
@show splitdir(jpath)
@show splitext(jpath)
@show basename(jpath)
@show dirname(jpath)
@show glob("*.jl")

for (root, dirs, files) in walkdir(".")
    println("Directories in $root")
    for dir in dirs
        println(joinpath(root, dir)) # path to directories
    end
    println("Files in $root")
    for file in files
        println(joinpath(root, file)) # path to files
    end
end

if !isdir("./myfolder/subfolder")
    mkpath("./myfolder/subfolder")
end
