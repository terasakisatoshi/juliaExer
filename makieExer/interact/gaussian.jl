using Makie
using AbstractPlotting: textslider
using Distributions: Normal, pdf

function single()
    s_μ, obs_μ = textslider(range(-1., stop=1., length=101), "μ", start=0)
    σ = 1
    #=
    pos = lift(obs_μ) do μ
            d = Normal(μ, σ)
            [Point2f0(x, pdf(d, x)) for x in -5.:0.02:5.]
        end
    =#

    pos = lift(μ ->begin
                        d = Normal(μ, σ)
                        [Point2f0(x, pdf(d, x)) for x in -5.:0.02:5.]
                   end,
                obs_μ
           )

    p = lines(pos)
    RecordEvents(
        hbox(
            p, 
            vbox(s_μ), 
            parent=Scene()
        ),
        "output"
    )
end

function main()
    s_μ, obs_μ = textslider(range(-1., stop=1., length=101), "μ", start=0)
    s_σ, obs_σ = textslider(range(0.1, stop=5.1, length=101), "σ", start=1)
    
    #=
    params = lift(tuple, obs_μ, obs_σ)
    pos = lift(params) do (μ, σ)
        d = Normal(μ, σ)
        map(LinRange(-5, 5, 100)) do x
            Point2f0(x, pdf(d, x))
        end
    end
    =#

    #=
    pos = lift((μ, σ) -> begin
                            d = Normal(μ, σ)
                            [Point2f0(x, pdf(d, x)) 
                                for x in -5.:0.02:5.]
                         end,
               obs_μ, obs_σ)
    =#

    pos = lift(lift(tuple, obs_μ, obs_σ)) do (μ, σ)
            d = Normal(μ, σ)
            [Point2f0(x, pdf(d, x)) for x in -5.:0.02:5.]
        end
    p = lines(pos)

    RecordEvents(
        hbox(
            p, 
            vbox(s_μ, s_σ), 
            parent=Scene()
        ),
        "output"
    )

end

main()