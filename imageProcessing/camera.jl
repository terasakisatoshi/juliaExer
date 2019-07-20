using PyCall: pyimport
using Images: warp, colorview, channelview, RGB, imresize
using CoordinateTransformations: LinearMap, RotMatrix

np = pyimport("numpy")
cv2 = pyimport("cv2")

function arr2rgb(img)
    img = Float32.(img ./ 255.0)
    #BGR2RGB
    img = img[:, :, reverse(1:end)]
    img = permutedims(img, (3,1,2))
    img = colorview(RGB, img)
    return img
end

function rgb2arr(img)
    img = channelview(img)
    img = permutedims(img, (2,3,1))
    #RGB2BGR
    img = img[:, :, reverse(1:end)]
    img = np[:asarray](255. .* img, dtype=np[:uint8])
    return img
end

function rotate(img, degree)
    rad = degree * pi / 180
    tfm = LinearMap(RotMatrix(rad))
    return warp(img, tfm)
end

function process_something(img)
    rot_img = rotate(img, 90)
    rot_img = imresize(rot_img, (224,224))
    return rot_img
end

function video()
    cap = cv2[:VideoCapture](0)
    if !cap[:isOpened]()
        print("Error opening video stream or file")
        exit(1)
    end

    while cap[:isOpened]()
        ret_val, img = cap[:read]()
        img = arr2rgb(img)
        img = imresize(img,(224,224))
        # do something on Julia
        new_img = process_something(img)
        # concat original and processed images
        concatenated = cat([img, new_img]..., dims=2)
        out = rgb2arr(concatenated)
        cv2[:imshow]("julia app press enter esc", out)
        if cv2[:waitKey](1) == 27
            #press `esc` key to exit
            break
        end
    end
end

video()
