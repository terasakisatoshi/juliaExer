
function count_upto_one()
    counter = 0
    accumulated = 0.0
    while true
        accumulated += rand()
        counter += 1
        if accumulated >= 1.0
            break
        end
    end
    return counter
end
