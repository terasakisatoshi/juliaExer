using LinearAlgebra, Statistics

import MPI, LinearAlgebra

function montecarlo(mc_eval::Function, mc_monitor::Function,
                    comm::MPI.Comm, # MPI communicator
                    n_evals::Integer, # total number of evaluations
                    n_returns::Integer, # number of return values per evaluation
                    batchsize::Integer=1) # transmission size
    rank = MPI.Comm_rank(comm)
    commsize = MPI.Comm_size(comm)

    @assert commsize > 1

    # bookkeeping
    if mod(n_evals, commsize-1) != 0
        if rank == 0
            println("Error (montecarlo):")
            println("    n_evals=$n_evals, commsize=$commsize")
            println("Choose commsize so that n_evals/(commsize-1) is integer")
        end
        MPI.Finalize()
        exit(1)
    end
    n_pernode = div(n_evals, commsize-1)

    # number of evaluations per worker
    if mod(n_pernode, batchsize) != 0
        batchsize = div(n_pernode, commsize-1)
    end
    if mod(n_pernode, batchsize) != 0
        if rank == 0
            println("Error (montecarlo):")
            println("    n_pernode=$n_pernode, batchsize=$batchsize")
            println("Choose commsize so that n_pernode/batchsize is integer")
        end
        MPI.Finalize()
        exit(1)
    end

    if rank > 0
        # workers
        contrib = zeros(batchsize, n_returns)
        @inbounds for i = 1:div(n_pernode, batchsize)
            # do work
            for j = 1:batchsize
                contrib[j,:] .= mc_eval()
            end
            MPI.Send(contrib, 0, 0, comm)
        end
    else
        # manager
        results = zeros(n_evals, n_returns)
        contrib = zeros(batchsize, n_returns)
        for nresults = 1:div(n_evals, batchsize)
            MPI.Recv!(contrib, MPI.ANY_SOURCE, 0, comm)
            results[nresults*batchsize-batchsize+1:nresults*batchsize,:] = contrib
            mc_monitor(nresults*batchsize, results)
        end
    end
end

function pi_wrapper()
    4.0 * (norm(rand(2)) < 1)
end

# this function reports intermediate results during MC runs
function pi_monitor(sofar, results)
    # Examine results every 12.5*10^5 draws
    if mod(sofar, 10^6) == 0
        m = mean(results[1:sofar,:],dims=1)
        println("reps: $sofar, pihat: $m")
    end
end

# do the monte carlo: 10^6 reps of single draws
function main()
    MPI.Init()
    n_evals = 10^7 # desired number of MC reps
    n_returns = 1
    batchsize = 10^5
    montecarlo(pi_wrapper, pi_monitor,
               MPI.COMM_WORLD, n_evals, n_returns, batchsize)
    MPI.Finalize()
end

main()
