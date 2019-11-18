#=
Capture image from webcamera.
The original implementation is taken from VideoIO.jl(see __init__ function)
=#

using Makie
using VideoIO

function play(f; flipx = false, flipy = false, pixelaspectratio = nothing)
    if pixelaspectratio ≡ nothing # if user did not specify the aspect ratio we'll try to use the one stored in the video file
        pixelaspectratio = VideoIO.aspect_ratio(f)
    end
    h = f.height
    w = round(typeof(h), f.width * pixelaspectratio) # has to be an integer
    scene = Makie.Scene(resolution = (w, h))
    buf = read(f)
    makieimg = Makie.image!(
        scene,
        1:h,
        1:w,
        buf,
        show_axis = false,
        scale_plot = false,
    )[end]
    Makie.rotate!(scene, -0.5pi)
    if flipx && flipy
        Makie.scale!(scene, -1, -1, 1)
    else
        flipx && Makie.scale!(scene, -1, 1, 1)
        flipy && Makie.scale!(scene, 1, -1, 1)
    end
    display(scene)
    while !eof(f) && isopen(scene)
        read!(f, buf)
        makieimg[3] = buf
        sleep(1 / f.framerate)
    end

end


function startdemo(pixelaspectratio = nothing)
    camera = opencamera()
    play(camera, flipx = true, pixelaspectratio = pixelaspectratio)
    close(camera)
end
