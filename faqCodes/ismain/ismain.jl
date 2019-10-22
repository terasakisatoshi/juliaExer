include("nomain.jl")


@show PROGRAM_FILE
@show @__DIR__
@show @__LINE__
@show abspath(PROGRAM_FILE) == @__FILE__
