using Distributions: Normal, MixtureModel, pdf
using HCubature
using Makie
using AbstractPlotting: textslider
const d = Normal(0, 1)

𝓝(x) = pdf.(d, x)
prior(x, a, b) = (1 - a) * 𝓝(x) + a * 𝓝(x - b)
ϕ(a, b) = 1. / 10.

domain_integral(f) = hcubature(x->f(x...), (0., -5.), (1., 5.))[1]

∏(v) = prod(v)
post(a, b, Xᴺ, β, Z) = ϕ(a, b) * ∏([prior(Xᵢ, a, b)^β for Xᵢ in Xᴺ])/Z

Ew(f, Xᴺ, β, Z) = domain_integral((a, b) -> f(a, b)*post(a, b, Xᴺ, β, Z))
pred(x, Xᴺ, β, Z) = Ew((a, b) -> prior(x, a, b), Xᴺ, β, Z)

function calc_partition(Xᴺ, β)
    domain_integral((a, b) -> ϕ(a, b) * ∏([prior(Xᵢ, a, b)^β for Xᵢ in Xᴺ]))
end


function main_dynamic()
    s_a₀, obs_a₀ = textslider(0. :0.01:1., "a₀", start=0.5)
    s_b₀, obs_b₀ = textslider(-5.:0.01:5., "b₀", start=3.0)
    n=100
    β = 1.
    alspace = 0.:0.01:1.
    blspace = -5.:0.01:5.
    function update!(z::Array{Float32, 2}, a₀, b₀)
        mixture = MixtureModel(
            Normal[
                Normal(0., 1.0),
                Normal(b₀, 1.0)
            ],
            [1 - a₀, a₀]
        )

        Xᴺ = rand(mixture, n)
        Z = calc_partition(Xᴺ, β)
        z = Float32[post(a, b, Xᴺ, β, Z)
                        for a in alspace, b in blspace]
    end

    args_n = (obs_a₀, obs_b₀)
    pos = lift(update!, Node(zeros(Float32, (n,n))), args_n...)
    sur = surface(alspace, blspace, pos)
    axis = sur[Axis]
    axis[:names][:axisnames] = ("a", "b", "post distribution")

    RecordEvents(
        hbox(
            sur,
            vbox(s_a₀, s_b₀),
            parent=Scene()
        ),
        "output"
    )
end

function main_static(a₀, b₀, n)
    β = 1.
    
    alspace = 0.:0.01:1.
    blspace = -5.:0.01:5.
    mixture = MixtureModel(
        Normal[
            Normal(0., 1.0),
            Normal(b₀, 1.0)
        ],
        [1 - a₀, a₀]
    )
    Xᴺ = rand(mixture, n)
    Z = calc_partition(Xᴺ, β)

    z = [post(a, b, Xᴺ, β, Z) for a in alspace, b in blspace]
    @show domain_integral((a,b) -> post(a, b, Xᴺ, β, Z))
    sur = surface(alspace, blspace, z)
    axis = sur[Axis]
    axis[:names][:axisnames] = ("a", "b", "post distribution")
    sur
end
