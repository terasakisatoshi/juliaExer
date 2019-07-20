# enumerate primes
#https://www.kaggle.com/dserdyuk/julia-primes


function main()
    primes = Int64[]
    i = 2
    while i < 1e7
        found = false
        for p in primes
            if i % p == 0
                found = true
                break
            end
            if p > √i # p > sqrt(i)
                break
            end
        end
        if !found
            push!(primes, i)
        end
        i += 1
    end

    f = open("jloutput.csv", "w")
    write(f, "primes\n")
    for p in primes
        write(f, "$(p)\n")
    end
end

tic()
main()
toc()