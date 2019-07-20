const libjulia_path = joinpath(Sys.BINDIR, Base.LIBDIR, "libjulia.dylib")
@show isfile(libjulia_path)
ccall((:jl_init,libjulia_path),Cvoid,(Ptr{Cvoid},),C_NULL)

