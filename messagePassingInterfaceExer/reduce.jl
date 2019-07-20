using MPI

using Printf

function do_reduce()
    comm = MPI.COMM_WORLD

    MPI.Barrier(comm)

    root = 0
    r = [1,2,3]
    op = (x, y) -> broadcast(*, x, 2y)
    sr = MPI.Reduce(r, op, root, comm)
    if MPI.Comm_rank(comm) == root
        @printf("sum of ranks: %s\n", sr)
    end
end

function main()
    MPI.Init()
    do_reduce()
    MPI.Finalize()
end

main()
