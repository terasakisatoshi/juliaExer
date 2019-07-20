import os
from ctypes import *
p=os.path.join(os.getcwd(),"builddir/example.dylib")
print("p=", p)
dll = CDLL(p,RTLD_GLOBAL)
dll.init_jl_runtime()