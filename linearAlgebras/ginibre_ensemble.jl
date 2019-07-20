using Distributions
using LinearAlgebra
using Plots

function gen_uniform_randmat(N,type)
    if type == :complex
        Re = rand(Uniform(-1, 1), N, N)
        Im = rand(Uniform(-1, 1), N, N)im
        A = Re + Im
    elseif type==:real
        A = rand(Uniform(-1, 1), N, N)
    else
        error("type should be :real or :complex")
    end
end


function gen_randnmat(N, type)
    if type == :complex
        randn(Complex{Float64}, N, N)
    elseif type==:real
        randn(N, N)
    else
        error("type should be :real or :complex")
    end
end


function main(N)
    A = gen_uniform_randmat(N, :complex)
    λs = eigvals(A)
    scatter(
        real(λs),
        imag(λs),
        aspect_ratio=:equal
    )
end

main(500)
