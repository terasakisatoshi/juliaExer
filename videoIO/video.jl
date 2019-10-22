import VideoIO
#using Plots
import AbstractPlotting


import Makie
using Images, CoordinateTransformations, OffsetArrays

function main_makie()
    f = VideoIO.opencamera()
    img = read(f)
    tfm = recenter(RotMatrix(pi/2), Images.center(img))
    img=parent(warp(img,tfm))
    scene = Makie.Scene(resolution = size(img))
    makieimg = Makie.image!(
        scene,
        img, 
        show_axis = false,
        scale_plot = true
    )[end]
    display(scene)

    while !eof(f)
        # OffsetArrays -> Array
        img=parent(warp(read(f),tfm))
        @info size(img)
        makieimg[1] = img
        sleep(1/f.framerate)
    end
end


function main_plots()
    img=AbstractPlotting.logo()
    p=plot(img) |> display
    for i in 1:100
        @info i
        plot(img, title="$i") |> display
    end
end
