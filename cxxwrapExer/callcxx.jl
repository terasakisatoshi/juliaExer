#ENV["LD_LIBRARY_PATH"]=joinpath(@__DIR__,"shared")

module CppHello
    using CxxWrap
    @wrapmodule(joinpath(@__DIR__,"libhello"))

    function __init__()
        @initcxx
    end
end


@show CppHello.greet()
