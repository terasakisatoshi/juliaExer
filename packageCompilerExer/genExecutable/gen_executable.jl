using PackageCompiler
PackageCompiler.force_native_image!()
build_executable("./hello.jl","hello")
