from util import trailing_zeros
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


def main():
    print(gcd(4, 5))
    print(gcd(-4, 8))
    print(gcd(3, 6))

if __name__ == '__main__':
    main()
