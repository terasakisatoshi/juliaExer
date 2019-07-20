using Metalhead
using Metalhead: classify

vgg = VGG19()
img = load("goma.jpeg")

@show classify(vgg, img)
