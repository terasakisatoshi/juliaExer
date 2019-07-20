using Printf: @printf
using MPI


function do_broadcast()
    comm = MPI.COMM_WORLD
    root = 0
    if MPI.Comm_rank(comm) == root
        println(repeat("-",78))
        println(" Running on $(MPI.Comm_size(comm)) processes")
        println(repeat("-",78))
    end

    MPI.Barrier(comm)

    N = 5

    if MPI.Comm_rank(comm) == root
        A = fill((1.0 + 2.0im), N)
    else
        A = Array{ComplexF64}(undef, N)
    end

    MPI.Bcast!(A, length(A), root, comm)

    @printf("[%02d] A:%s\n", MPI.Comm_rank(comm), A)

    if MPI.Comm_rank(comm) == root
        B = Dict("foo" => "bar")
    else
        B = nothing
    end

    B = MPI.bcast(B, root, comm)
    @printf("[%02d] B:%s\n", MPI.Comm_rank(comm), B)


    if MPI.Comm_rank(comm) == root
        f = x -> x^2 + 2x - 1
    else
        f = nothing
    end

    f = MPI.bcast(f, root, comm)
    @printf("[%02d] f(3):%d\n", MPI.Comm_rank(comm), f(3))
end

function main()
    MPI.Init()
    do_broadcast()
    MPI.Finalize()
end

main()
