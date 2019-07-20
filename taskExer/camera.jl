#=
Example of camera application using coroutine
=#

using PyCall


const np = pyimport("numpy")
const cv2 = pyimport("cv2")
# add current path to enable import local modules
pushfirst!(PyVector(pyimport("sys")."path"), "")
const classifier = pyimport("classifier")
const pyutils = pyimport("utils")

const labels = pyutils.load_labels()
const model = PyNULL()
const cap = PyNULL()

const camworker = Channel{Array{UInt8, 3}}(0)
# const color_dim = 2 # if gray
const color_dim = 3 # if color
dType=Tuple{Array{UInt8,3},Array{Int64,1},Array{Float32,1}}
const imgworker = Channel{dType}(0)


function init_camera()
    if cap == PyNULL()
        copy!(cap, cv2.VideoCapture(0))
    end
end


function capture_camera(;color_fmt=:rgb, display_size=(640, 640))
    @info "start" "capture_camera"
    init_camera()
    if !cap.isOpened()
        print("Error opening video stream or file")
        exit(1)
    end
    while cap.isOpened()
        ret_val, img = cap.read()
        if color_fmt == :rgb
            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        elseif color_fmt == :gray
            img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        end
        img = cv2.resize(classifier.clip_image(img), display_size)
        put!(camworker, img)
    end
    @info "end" "capture_camera"
end


function process_image()
    @info "start" "process_image"
    while true
        img = take!(camworker)
        top_k, prediction = model(img)
        data = (img, top_k, prediction)
        put!(imgworker, data)
    end
    @info "end" "process_image"
end


function cleanup()
    # stop camera capture
    if cap != PyNULL()
        @info "release capture"
        cap.release()
    end

    @info "stop workers"
    close(camworker)
    close(imgworker)

    @info "destroy all windows"
    # close cv2 windows
    cv2.waitKey(1)
    cv2.destroyAllWindows()
    cv2.waitKey(1)

    @info "cleanup" "finish"
end


function visualize(;display_size=(640, 640))
    @info "start" "visualize"
    start = time()
    while isopen(imgworker)
        img, top_k, prediction = take!(imgworker)
        elapsed = time() - start
        canvas = classifier.create_canvas(labels, top_k, prediction, display_size, elapsed)
        start = time()
        dispimg = cv2.cvtColor(hcat([img, canvas]...), cv2.COLOR_RGB2BGR)
        cv2.imshow("julia app press enter [esc] key", dispimg)
        # press esc to exit
        if cv2.waitKey(1) == 27
            cleanup()
            break
        end
    end
    @info "end" "visualize"
end


function definemodel()
    copy!(labels, pyutils.load_labels())
    multiplier = 1.0
    input_size = 224
    mobilenetversion = classifier.VERSION
    modelname = "mobilenet_$(mobilenetversion)_$(multiplier)_$input_size"
    pyutils.download_checkpoint(multiplier, input_size)
    checkpoint = joinpath(pyutils.SAVEDIR, modelname, "$(modelname).tflite")
    copy!(model, classifier.TFModel(checkpoint))
end


function sequential(display_size=(640, 640))
    definemodel()
    init_camera()
    if !cap.isOpened()
        print("Error opening video stream or file")
        exit(1)
    end
    start = time()
    while cap.isOpened()
        ret_val, img = cap.read()
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = cv2.resize(classifier.clip_image(img), display_size)
        top_k, prediction = model(img)
        elapsed = time() - start
        canvas = classifier.create_canvas(labels, top_k, prediction, display_size, elapsed)
        start = time()
        dispimg = cv2.cvtColor(hcat([img, canvas]...), cv2.COLOR_RGB2BGR)
        cv2.imshow("julia app press enter [esc] key", dispimg)
        # press esc to exit
        if cv2.waitKey(1) == 27
            cap.release()
            cv2.waitKey(1)
            cv2.destroyAllWindows()
            cv2.waitKey(1)
            break
        end
    end
end


function calldirect()
    copy!(labels, pyutils.load_labels())
    multiplier = 1.0
    input_size = 224
    mobilenetversion = classifier.VERSION
    modelname = "mobilenet_$(mobilenetversion)_$(multiplier)_$input_size"
    pyutils.download_checkpoint(multiplier, input_size)
    checkpoint = joinpath(pyutils.SAVEDIR, modelname, "$(modelname).tflite")
    classifier.predict_using_tflite(checkpoint, labels)
end


# $ julia -L camera.jl
#julia> main()
function main()
    definemodel()
    captask = @async capture_camera()
    proctask = @async process_image()
    vistaks = @async visualize()
    return captask, proctask, vistaks
end

