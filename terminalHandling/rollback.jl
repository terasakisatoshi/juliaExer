
using Crayons
using Crayons.Box
using InteractiveUtils
using ColorTypes
using ImageInTerminal
using ImageCore

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

function goma(c,H,W; init::Bool=false)
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
    for i in 1:H
        print(buf, "\x1b[2K") # clear line
        print(buf, "\x1b[999D\x1b[$(1)A") # rollback
    end
    print(buf |> take! |> String)
end

function v()
    H,W=5,10
    goma(BLACK_BG,H,W,init=true)
    for c in BG_COLORS
        goma(c,H,W)
        sleep(0.1)
    end
    clean(H)
end

function iv()
    inH,inW=240,320
    imgA =colorview(RGB, zeros(3, inH,inW))
    imgB =colorview(RGB, ones(3, inH,inW))
    outH,outW=displaysize()
    init = true
    for img in repeat([imgA,imgB],3)
        buf=IOBuffer()
        if !init
            print(buf, "\x1b[999D\x1b[$(outH)A")
        else
            init = false
        end
        ImageInTerminal.imshow(buf,img)
        println(buf |> take! |> String)
        sleep(0.5)
    end
    clean(outH)
end

v()

iv()
