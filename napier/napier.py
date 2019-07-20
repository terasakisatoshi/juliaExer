import numpy as np
from numba import jit, prange


@jit(nopython=True)
def count_upto_one():
    counter = 0
    accumulated = 0.0
    while True:
        accumulated += np.random.random()
        counter += 1
        if accumulated >= 1.0:
            break
    return counter


@jit(nopython=True, parallel=True)
def main():
    n_trial = int(1e9)
    total_count = 0
    for _ in prange(n_trial):
        total_count += count_upto_one()
    print(total_count / n_trial)


if __name__ == '__main__':
    main()
