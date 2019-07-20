using Distributed

function calc_napier_parallel()
    n_trial =1e9
    total_count = @distributed (+) for i in 1:n_trial
        counter = 0
        accumulated = 0.0
        while true
            accumulated += rand()
            counter += 1
            if accumulated >= 1.0
                break
            end
        end
        counter
    end
    println(total_count/n_trial)
end

addprocs()

