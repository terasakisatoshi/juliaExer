import math
from numba import jit, prange
import time
import numpy as np


@jit('i8(i8,i8)', nopython=True)
def gcd(a, b):
    """
    Reference:
    https://qiita.com/wrist/items/889696a507fbc8b392e4
    http://swdrsker.hatenablog.com/entry/2017/12/20/235201
    https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.remainder.html
    """
    while b != 0:
        #a, b = b, a % b
        a, b = b, np.remainder(a, b)
    return a


@jit('f8(i8)', nopython=True)
def calc_pi_by_gcd(N):
    s = 0
    for a in range(1, N+1):
        for b in range(1, N+1):
            if gcd(a, b) == 1:
                s += 1
    pi = math.sqrt(6*N**2/s)
    return pi


@jit('f8(i8)', nopython=True, parallel=True)
def calc_pi_by_gcd_parallel(N):
    s = 0
    for a in prange(1, N+1):
        for b in range(1, N+1):
            if gcd(a, b) == 1:
                s += 1
    pi = math.sqrt(6*N**2/s)
    return pi


def main():
    start = time.time()
    pi = calc_pi_by_gcd(10000)
    end = time.time()
    print(pi)
    print("Elapsed time=", end-start)

    start = time.time()
    pi = calc_pi_by_gcd_parallel(10000)
    end = time.time()
    print(pi)
    print("Elapsed time=", end-start)

if __name__ == '__main__':
    main()
