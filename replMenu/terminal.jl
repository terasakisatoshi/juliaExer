
import REPL
using REPL.TerminalMenus
using Plots

options = ["sin", "cos", "sinh", "cosh", "exp"]
menu = MultiSelectMenu(options)

function main()
    choices = request("Select the function you like to plot:", menu)
    p = plot()
    if length(choices) > 0
        println("plot")
        x = -π:0.01:π
        for i in choices
            fname = options[i]
            f = eval(Meta.parse(fname))
            println("func name = $f")
            plot!(p, f, x)
        end
    else
        println("Menu canceled")
    end
    return p
end

main() |> display
