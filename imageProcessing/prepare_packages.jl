using Pkg
Pkg.add("Images")
Pkg.add("ImageMetadata")
Pkg.add("ImageView")
Pkg.add("TestImages")
Pkg.add("ImageMagick")
Pkg.update()

# validation
using Images, ImageMetadata, TestImages, ImageView, ImageMagick
