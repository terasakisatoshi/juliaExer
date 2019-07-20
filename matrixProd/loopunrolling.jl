using Test

function naive!(C, A, B)
    row, col = size(C)
    colA = size(A)[2]
    for i in 1:row
        for j in 1:col
            for k in 1:colA
                C[i, j] = C[i, j] + A[i, k] * B[k, j]
            end
        end
    end
end


function unroll_k!(C, A, B)
    row, col = size(C)
    colA = size(A)[2]
    for i in 1:row
        for j in 1:col
            for k in 1:2:colA
                C[i, j] = C[i, j] + A[i, k] * B[k, j] + A[i, k+1] * B[k+1, j]
            end
        end
    end
end


function unroll_j!(C, A, B)
    row, col = size(C)
    colA = size(A)[2]
    for i in 1:row
        for j in 1:2:col
            for k in 1:colA
                C[i,   j] = C[i, j] + A[i, k] * B[k, j]
                C[i, j+1] = C[i, j+1] + A[i, k] * B[k, j+1]
            end
        end
    end
end


function unroll_i!(C, A, B)
    row, col = size(C)
    colA = size(A)[2]
    for i in 1:2:row
        for j in 1:col
            for k in 1:colA
                C[i,   j] = C[i,   j] + A[i,   k] * B[k, j]
                C[i+1, j] = C[i+1, j] + A[i+1, k] * B[k, j]
            end
        end
    end
end


function unroll_ij!(C, A, B)
    row, col = size(C)
    colA = size(A)[2]
    for i in 1:2:row
        for j in 1:2:col
            for k in 1:colA
                C[i ,  j] = C[i,   j] + A[i, k] * B[k, j]
                C[i+1, j] = C[i+1, j] + A[i+1, k] * B[k ,j]
                C[i, j+1] = C[i, j+1] + A[i, k] * B[k, j+1]
                C[i+1, j+1] = C[i+1, j+1] + A[i+1, k] * B[k, j+1]
            end
        end
    end
end


function main(N)
    A = reshape(convert.(Float64, collect(1:N^2)), N, N)
    B = reshape(convert.(Float64, collect(1:N^2)), N, N)
    C = zeros(N, N)
    @time refC = A * B
    C = zeros(N, N)
    @time naive!(C, A, B)
    C = zeros(N ,N)
    @time unroll_k!(C, A, B)
    @test C ≈ refC
    C = zeros(N, N)
    @time unroll_i!(C, A, B)
    @test C ≈ refC
    C = zeros(N, N)
    @time unroll_j!(C, A, B)
    @test C ≈ refC
    C = zeros(N, N)
    @time unroll_ij!(C, A, B)
    @test C ≈ refC
end
