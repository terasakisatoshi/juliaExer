using Plots
using LaTeXStrings

pyplot()

x = -π:0.01:π

p0=plot(x,sin.(x),title="naive plot")

p1=plot(
    x,
    sin.(x),
    xticks=(
        [-pi,-pi/2,0,pi/2,pi],
        ["-\$\\pi\$","-\$\\pi\$/2","0","\$\\pi\$/2","-\$\\pi\$"]
    ),
    title="sine-curve",
    label="\$\\sin\$ function",
    xlabel="\$x\$",
    ylabel="\$y\$",
    color="green",
)

p2=plot(
    x,
    cos.(x),
    xticks=(
        [-pi,-pi/2,0,pi/2,pi],
        [L"-\pi",L"-\frac{\pi}{2}","0",L"\frac{\pi}{2}",L"\pi"],
    ),
    title="cosine-curve",
    label=L"y=\cos(x)",
    xlabel=L"x",
    ylabel=L"y",
    color=:purple,
)

plot(p0, p1, p2, layout=(3,1))
