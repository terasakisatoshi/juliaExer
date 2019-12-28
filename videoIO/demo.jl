#=
Capture image from webcamera.
The original implementation is taken from VideoIO.jl(see __init__ function)
=#

using Makie
using VideoIO

function center_crop(img)
    imW, imH = size(img)
    sz = min(imH, imW)
    y_offset = round(Int,(imH - sz) / 2.)
    x_offset = round(Int,(imW - sz) / 2.)
    y_slice = range(1+y_offset, stop=y_offset+sz)
    x_slice = range(1+x_offset, stop=x_offset+sz)
    cropped = img[x_slice, y_slice]
    cropped
end

function play(f; flipx = false, flipy = false, pixelaspectratio = nothing)
    if pixelaspectratio ≡ nothing # if user did not specify the aspect ratio we'll try to use the one stored in the video file
        pixelaspectratio = VideoIO.aspect_ratio(f)
    end
    sz=min(f.height, f.width)
    scene = Makie.Scene(resolution = (sz,sz))
    buf = read(f)
    disp=center_crop(buf)
    makieimg = Makie.image!(
        scene,
        1:sz,
        1:sz,
        disp,
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
        disp=center_crop(buf)
        makieimg[3] = disp
        sleep(1 / f.framerate)
    end

end


function begindemo(pixelaspectratio = nothing)
    camera = opencamera()
    play(camera, flipx = true, pixelaspectratio = pixelaspectratio)
    close(camera)
end
