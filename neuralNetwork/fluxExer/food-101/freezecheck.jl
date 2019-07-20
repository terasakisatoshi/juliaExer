using Flux
using Metalhead

function main()
    vgg = VGG19()
    Flux.testmode!(vgg, false)
    model = Chain(vgg.layers[1:end-2],
                  Dense(4096, 101),
                  softmax)
    Flux.testmode!(model,false)

    val_model = model |> cpu
    println(model)
    println(val_model)
    Flux.testmode!(val_model)
    println(model)
    println(val_model)
end

main()
