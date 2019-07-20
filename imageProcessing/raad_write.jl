using Images, ImageView

function main()
    img = load("julia.jpeg")
    grayimg=Gray.(img)
    save("gray.png",grayimg)

    img = rand(368, 224, 3)
    # HxWxC ???
    #No! Actual this generates 3-images!!!
    save("img368x224.png",img)

    #img = rand(3,368,224)
    #save("img_3x368x224.png",img) dangerous do not do this

    color_g = 0.7 * ones(3,224,448) #CxHxW
    color_g = colorview(RGB, color_g)
    save("color_g.png",color_g)

    ch=color_g[120,400]
    #@show ch
    #@show red(ch)
    #@show blue(ch)
    #@show green(ch)
    #@show colorview(RGB,Gray.(rand(128,224)),Gray.(rand(128,224)),Gray.(rand(128,224)))
    img=colorview(RGB,rand(3,128,224))
    save("randgen.png",img)
end

main()
