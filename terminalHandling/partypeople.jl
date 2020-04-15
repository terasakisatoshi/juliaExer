#=
julia --color=yes guruguru.jl
=#

using Crayons
using Crayons.Box
using ColorTypes


const SPACE = " " # one white space
BG_COLORS=[
    #BLACK_BG         ,
    RED_BG           ,
    GREEN_BG         ,
    YELLOW_BG        ,
    BLUE_BG          ,
    MAGENTA_BG       ,
    CYAN_BG          ,
    LIGHT_GRAY_BG    ,
    DEFAULT_BG       ,
    DARK_GRAY_BG     ,
    LIGHT_RED_BG     ,
    LIGHT_GREEN_BG   ,
    LIGHT_YELLOW_BG  ,
    LIGHT_BLUE_BG    ,
    LIGHT_MAGENTA_BG ,
    LIGHT_CYAN_BG    ,
    WHITE_BG         ,
]

function draw(c,H,W; init::Bool=false)
    H,W = 5,10
    buf = IOBuffer()
    if !init
        print(buf, "\x1b[999D\x1b[$(H)A") #rollback H-times
    end
    for i in 1:H
        msg = repeat("$(rand(1:9))",W)
        println(buf, c, msg, Crayon(reset=true))
    end
    print(buf |> take! |> String)
end

function clean(H)
    buf = IOBuffer()
    for i in 1:H+1
        print(buf, "\x1b[2K") # clear line
        print(buf, "\x1b[999D\x1b[$(1)A") # rollback
    end
    print(buf |> take! |> String)
end

function partypeople()
    H,W=5,10
    draw(BLACK_BG,H,W,init=true)
    for c in BG_COLORS
        draw(c,H,W)
        sleep(0.1)
    end
    clean(H)
end

partypeople()

