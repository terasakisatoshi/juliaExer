import REPL
using REPL.TerminalMenus
using Plots


options=["sin","cos"]
menu = RadioMenu(options)

choice=request("どの関数を描画したいですか？", menu)

if choice != -1
    plot(eval(Meta.parse(options[choice])),-π:0.01:π)
else
    println("Menu canceled")
end
