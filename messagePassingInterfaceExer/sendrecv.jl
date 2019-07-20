using MPI


function do_sendrecv()
    comm  = MPI.COMM_WORLD
    MPI.Barrier(comm)

    rk = MPI.Comm_rank(comm)
    sz = MPI.Comm_size(comm)

    dst = mod(rk+1, sz)
    src = mod(rk-1, sz)

    N = 4

    send_msg = Array{Float64}(undef,N)
    fill!(send_msg, Float64(rk))
    recv_msg = Array{Float64}(undef,N)

    tag = 1
    r_req = MPI.Irecv!(recv_msg, src, tag, comm)
    println("$rk: Sending, $rk -> $dst = $send_msg")

    s_req  = MPI.Isend(send_msg,dst,tag, comm)

    stats = MPI.Waitall!([r_req,s_req])
    println("$rk: Receiving $src -> $rk = $recv_msg")

    MPI.Barrier(comm)

end

function main()
    MPI.Init()
    do_sendrecv()
    MPI.Finalize()
end

main()
