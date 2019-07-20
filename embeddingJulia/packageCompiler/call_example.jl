const dylibpath="builddir/example.dylib"
@show ccall((:empty,dylibpath),Cint,(Ptr{Cvoid},),C_NULL)

@info "call init_jl_runtime"
@show ccall((:init_jl_runtime,dylibpath),Cvoid,(Ptr{Cvoid},),C_NULL)
@info "try to call bar_segfault"

@show ccall((:bar_segfault,dylibpath),Cint,(Cint,),Cint(100))
