"""
usage

$ make
$ python call_shared_from.py
rotateZ(pi / 6, Float64[1, 0, 0]) = [0.866025, 0.5, 0.0]
xxx = 3
Hello From Python World
[0.86602529 0.50000019 0.        ]
Hello From Python World
mean elapsed 230.35788536071777 mu-sec
mean elapsed 5.580425262451172 mu-sec
"""

import time
import math
import ctypes
from ctypes import cdll
import os
import numpy as np

import timeit


class JL_App(object):

    def __init__(self, lib_path):
        self.lib = cdll.LoadLibrary(lib_path)
        self.lib.initialize()

    def __enter__(self):
        return self.lib

    def __exit__(self, type_, value, traceback):
        self.lib.finalize()
        return True


def main():
    # use context manager to control jl_init and jl_atexit
    with JL_App("jl_application.dylib") as jl_app:
        jl_app.using_Rotations()
        jl_app.rot_z.argtypes = [
            np.ctypeslib.ndpointer(flags="F"),
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_double,
        ]
        theta = np.pi/6
        arr = np.empty(shape=(3), dtype=np.float64, order="F")
        jl_app.rot_z(arr, theta, 1., 0., 0.)
        print("Hello From Python World")
        print(arr)


def rot_about_z(theta, vec):
    rotz = np.array([
        [math.cos(theta), -math.sin(theta), 0],
        [math.sin(theta),  math.cos(theta), 0],
        [0, 0, 1],
    ]).transpose()
    return vec.dot(rotz)


def bench():
    # use context manager to control jl_init and jl_atexit
    with JL_App("jl_application.dylib") as jl_app:
        jl_app.using_Rotations()
        jl_app.rot_z.argtypes = [
            np.ctypeslib.ndpointer(flags="F"),
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_double,
        ]
        theta = np.pi/6
        import time
        stats = []
        arr = np.empty(shape=(3), dtype=np.float64, order="F")
        for i in range(1000):
            theta = 2*np.pi*np.random.random()
            vec = np.random.random(3)
            s = time.time()
            jl_app.rot_z(arr, theta, *vec)
            e = time.time()
            stats.append(1000*(e-s))
        print("Hello From Python World")
        print("mean elapsed", 1000*np.array(stats).mean(), "mu-sec")

    stats = []

    for i in range(1000):
        theta = 2*np.pi*np.random.random()
        vec = np.random.random(3)
        s = time.time()
        res = rot_about_z(theta, vec)
        e = time.time()
        stats.append(1000*(e-s))
    print("mean elapsed", 1000*np.array(stats).mean(), "mu-sec")


if __name__ == '__main__':
    main()
    bench()
