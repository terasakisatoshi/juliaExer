
function calc_napier()
    n_trial =convert(Int,1e8)
    total_count=0
    for i in 1:n_trial
        counter = 0
        accumulated = 0.0
        while true
            accumulated += rand()
            counter += 1
            if accumulated >= 1.0
                break
            end
        end
        total_count+=counter
    end
    total_count/n_trial
end
