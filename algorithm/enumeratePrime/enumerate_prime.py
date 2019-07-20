# enumerate primes which is converted Julia from Python

import math
import time

from numba import jit


@jit
def enumerate_primes():
    primes = []

    i = 2
    while i < 1e7:
        divisible = False
        for p in primes:
            if i % p == 0:
                divisible = True
                break
            if p > math.sqrt(i):
                break
        if not divisible:
            # i must be a prime
            primes.append(i)
        i += 1
    return primes


def output(primes):
    with open("pyoutput.csv", "w") as f:
        f.write("primes\n")
        for p in primes:
            f.write("{}\n".format(p))

if __name__ == '__main__':
    start = time.time()
    output(enumerate_primes())
    end = time.time()
    print("elapsed=", end - start, "[s]")
