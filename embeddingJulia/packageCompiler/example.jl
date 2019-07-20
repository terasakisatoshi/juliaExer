module Example

Base.@ccallable empty()::Cint = 10
Base.@ccallable foo(x::Cint)::Cint = 3
Base.@ccallable function bar(x::Cint)::Cint
    return 3
end

Base.@ccallable function just_print()::Cvoid
    print("Example")
end

Base.@ccallable function bar_segfault(x::Cint)::Cint
    println("Example")
    return 3
end

Base.@ccallable function example(x::Cint)::Cint
    return x
end
end
