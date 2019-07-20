
module PiCamera
using PyCall

export picamera, init_pygame, demo

const picamera = PyNULL()
const pygame = PyNULL()
const np = PyNULL()
const PiRGBArray = PyNULL()
const Image = PyNULL()

function __init__()
    pushfirst!(PyVector(pyimport("sys")."path"), "")
    copy!(picamera, pyimport("picamera"))
    copy!(pygame, pyimport("pygame"))
    copy!(np, pyimport("numpy"))
    picamera_array=pyimport("picamera.array")
    copy!(PiRGBArray, picamera_array.PiRGBArray)
    copy!(Image, pyimport("PIL.Image"))
end

# use frame buffer console
ENV["SDL_VIDEODRIVER"] = "fbcon"

function init_pygame()
    pygame.init()
end

py"""
from PIL import Image
import numpy as np

def np2pil(x):
    return Image.fromarray(x.astype(np.uint8))
"""


"""
convert np array to pil data
"""
function np2pil(x)
    py"np2pil"(x)
end    

function clip_image(x)
    py"clip_image"(x)
end

"""
display image taken by picamera
"""
function demo()
    pyutils = pyimport("utils")
    labels = pyutils.load_labels()
    classifier = pyimport("classifier")
    
    multiplier = 1.0
    input_size = 224
    mobilenetversion = classifier.VERSION
    modelname = "mobilenet_$(mobilenetversion)_$(multiplier)_$input_size"
    pyutils.download_checkpoint(multiplier, input_size)
    checkpoint = joinpath(pyutils.SAVEDIR, modelname, "$(modelname).tflite")
    model = classifier.TFModel(checkpoint)

    pygame.init()
    screen_size = (
        pygame.display.Info().current_w,
        pygame.display.Info().current_h
    )
    newsize = (min(screen_size...), min(screen_size...))
    screen = pygame.display.set_mode(screen_size)
    screen.fill((128,128,128)) # set background as gray
    pygame.display.update()
    # set destination where to display image
    dest = [
        (screen_size[1] - newsize[1])/2,
        (screen_size[2] - newsize[2])/2
    ]
    dest = map(x -> floor(Int, x), dest)
    dest[1] -= ceil(Int, dest[2]/3)
    @pywith picamera.PiCamera() as camera begin
        @pywith PiRGBArray(camera) as stream begin
            #camera.resolution = (640, 640)
            start = time()
            while true
                for event in pygame.event.get()
                    if event.type == pygame.KEYDOWN && event.key == pygame.K_ESCAPE
                        pygame.display.quit()
                        pygame.quit()
                    end
                end
                camera.capture(stream, "rgb", use_video_port=true)
                stream.seek(0)
                                
                npImg = classifier.clip_image(stream.array)
                pilImg = np2pil(npImg).resize(newsize)
                top_k, prediction = model(npImg)
                elapsed = time() - start
                @show 1/elapsed
                canvas = classifier.create_canvas(labels, top_k, prediction, newsize[2], elapsed)
                start = time()
                dispImg = hcat([np.array(pilImg), canvas]...)
                dispImg = permutedims(dispImg, (2,1,3))
                img = pygame.surfarray.make_surface(dispImg)
                screen.blit(img, dest)
                stream.truncate(0)
                pygame.display.update()
            end
        end
    end
end
end # end of module
