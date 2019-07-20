import math
from numba import jit
import time

@jit('i8(i8)',nopython=True)
def trailing_zeros(n):
    order = 0
    while (n & 1) == 0:
        order += 1
        n //= 2
    return order

@jit('f8(i8,i8)',nopython=True)
def gcd(a, b):
    if a == 0:
        return abs(b)
    if b == 0:
        return abs(a)
    za = trailing_zeros(a)
    zb = trailing_zeros(b)
    k = min(za, zb)

    u = abs(a >> za)
    v = abs(b >> zb)

    while u != v:
        if u > v:
            u, v = v, u
        v -= u
        v >> trailing_zeros(v)

    r = u << k
    return r


@jit('f8(i8)',nopython=True)
def calc_pi_by_gcd(N):
    s = 0
    for a in range(1, N+1):
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

if __name__ == '__main__':
    main()
