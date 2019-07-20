using Blink
using CSV
using DataFrames
using Interact
using Plots

# specify backend
plotlyjs()

function main()
    df1 = DataFrame(Any[10*randn(500), 10*rand(500), 10*rand(500)], [:AAA, :BBB, :CCC])
    @show names(df1)
    CSV.write("sample.csv", df1)
    loadbutton = filepicker()
    columnbuttons = Observable{Any}(dom"div"())
    data = Observable{Any}(DataFrame)
    plt = Observable{Any}(plot())
    map!(CSV.read, data, loadbutton)

    function makebuttons(df)
        buttons = button.(string.(names(df)))
        for (btn, name) in zip(buttons, names(df))
            map!(t -> histogram(df[name]), plt, btn)
        end
        dom"div"(hbox(buttons))
    end

    map!(makebuttons, columnbuttons, data)

    ui = dom"div"(loadbutton, columnbuttons, plt)

    w = Window()
    body!(w, ui)
end
