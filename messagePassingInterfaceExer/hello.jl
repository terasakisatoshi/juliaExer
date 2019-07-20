using MPI

function do_hello()
    comm = MPI.COMM_WORLD
    rk = MPI.Comm_rank(comm)
    sz = (MPI.Comm_size(comm))
    println("Hello world, I'm $(rk) of $(sz)")
    MPI.Barrier(comm)
end

function main()
    MPI.Init()
    do_hello()
    MPI.Finalize()
end

main()
