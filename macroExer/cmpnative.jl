function myfunc(x)
    sum(x)
end

function myfloatabstract(x::AbstractArray{Float64,N}) where {N}
    sum(x)
end

function myadd(x, y)
    x + y
end

function myintadd(x::Int, y::Int)
    x + y
end

"""
    communicate(cmd::Cmd, input)
https://discourse.julialang.org/t/collecting-all-output-from-shell-commands/15592/6
"""
function execute(cmd::Cmd)
    out = Pipe()
    err = Pipe()

    process = run(pipeline(ignorestatus(cmd), stdout = out, stderr = err))
    close(out.in)
    close(err.in)
    # To avoid the deadlock situation inherent in doing IO operations sequentially
    stdout = @async String(read(out))
    stderr = @async String(read(err))
    (out = String(read(out)), err = String(read(err)), code = process.exitcode)
end


for sym in [:native, :llvm]
    code_func = Symbol("code_$sym")
    funcname = Symbol("cmp_code_$sym")
    @eval begin
        @doc """
            cmp_$($code_func)(f::Function, g::Function, args...)
        Compare output of @$($funcname) between `f(args)` and `g(args)`
        if they are different this function shows with message `Files are different`
        """
        function $funcname(f::Function, g::Function, args...)
            t1, t2 = tempname(), tempname()
            open(t1, "w") do file
                $code_func(file, f, typeof.(args); debuginfo = :none)
            end
            open(t2, "w") do file
                $code_func(file, g, typeof.(args); debuginfo = :none)
            end
            result = execute(`diff $t1 $t2`)
            ret = result[:code]
            if ret == 0
                println("They are same")
            elseif ret == 1
                print(result[:out])
            else
                print(result[:err])
            end
            return nothing
        end
    end
end

cmp_code_native(myadd, myintadd, 2, 3)
cmp_code_llvm(myadd, myintadd, 2, 3)
