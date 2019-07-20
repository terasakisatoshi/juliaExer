module AoTImageSample

using Images
using TestImages, Images, ImageView

function main()
    img = load("julia.jpeg")
    save("aot_result.png",img)
    img = testimage("mandrill")
    imshow(img)
end

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    main()
    return 0
end

end
