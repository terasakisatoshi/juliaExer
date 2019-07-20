using Random


function preparedata(N::Int)
    A = Array{Float64}(undef, N,N)
    b = rand(N);
    c = rand(N);
    A, b, c
end

function bench1!(A, b, c)
    col  = size(A)[2]
    for i in 1:col
        A[1, i] = b[i] * c[i]
    end
end

function bench2!(A, b, c)
    row = size(A)[1]
    for i in 1:row
        A[i, 1] = b[i] * c[i]
    end
end

function main(N)
    Random.seed!(1234);
    A, b, c = preparedata(N)
    @time bench1!(A, b, c)
    @time bench2!(A, b, c)
end

