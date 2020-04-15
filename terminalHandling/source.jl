import REPL
using REPL.TerminalMenus
TerminalMenus.config(
    scroll = :wrap,
    ctrl_c_interrupt = false,
    cursor = '▶',
    up_arrow = '🔼',
    down_arrow = '🔽',
)

#ごまちゃんが発話できる種類
options = ["goma", "kyu", "kyueeen", "Q", "ℚ", "ℂ", "ℤ", "ℕ"]
menu = RadioMenu(options, pagesize = 4)
message = "Choose your favorite fruit:\n(press `q` or `Ctrl-c` to cancel)"
choice = request(message,menu)

@show choice

if choice != -1
    println("Your favorite fruit is ", options[choice], "!")
else
    println("Menu canceled.")
end
