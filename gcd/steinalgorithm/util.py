from numba import jit


@jit('i8(i8)')
def trailing_zeros_jit(n):
    order = 0
    while n != 1:
        d, m = divmod(n, 2)
        if m != 0:
            break
        n //= 2
        order += 1
    return order


@jit('i8(i8)')
def trailing_zeros(n):
    order = 0
    while (n & 1) == 0:
        order += 1
        n //= 2
    return order


def main():
    print(trailing_zeros_jit(32))
    print(trailing_zeros(32))

if __name__ == '__main__':
    main()
