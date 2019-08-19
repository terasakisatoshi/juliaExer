FROM julia:1.1.1

RUN apt-get update && \
    apt-get install -y build-essential git python3
RUN git clone https://github.com/kdheepak/PackageCompiler.jl.git && \
    cd PackageCompiler.jl && \
    git checkout -b fix-shared-library-compilation origin/kd/fix-shared-library-compilation
WORKDIR PackageCompiler.jl
RUN echo '\n\
Base.@ccallable foo(x::Cint)::Cint = 42\n\
Base.@ccallable bar(x::Cint)::Cint = x\n\
' > hello.jl
RUN julia --project=./Project.toml -e 'using Pkg; Pkg.add(["ArgParse"]); pkg"build"' && \
    julia --project=./Project.toml juliac.jl -vasij `pwd`/hello.jl
ENV JULIA_DIR=/usr/local/julia
# build test.c
RUN echo "#include <julia.h>\nJULIA_DEFINE_FAST_TLS()" > test.c && \
    echo "int main(int argc, char *argv[]){" >> test.c && \
    echo 'jl_init__threading();\njl_eval_string("println(sqrt(2.0))");\njl_atexit_hook(0);\nreturn 0;\n' >> test.c && \
    echo "}" >> test.c && \
    gcc -o output test.c \
    -DJULIA_ENABLE_THREADING=1 \
    -I$JULIA_DIR/include/julia \
    -L$JULIA_DIR/lib/julia \
    -L$JULIA_DIR/lib \
    -ljulia -Wl,-rpath -Wl,$JULIA_DIR/lib -Wl,-rpath -Wl,$JULIA_DIR/lib/julia && ./output
RUN mkdir -p ./lib/julia
RUN which julia
# create python file named runfrom.py to call hello.so
RUN echo '\n\
import ctypes\n\
lib=ctypes.CDLL("builddir/hello.so", ctypes.RTLD_GLOBAL)\n\
print(lib.init_jl_runtime())\n\
print(lib.foo(42))\n\
print(lib.bar(42))\n\
' > runfrom.py && python3 runfrom.py