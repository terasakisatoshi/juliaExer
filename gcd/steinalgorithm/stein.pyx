cdef int trailing_zeros(int n):
    cdef:
        int order = 0
        int m 
    while n != 1:
        m=n%2
        if m != 0:
            break
        n //= 2
        order += 1
    return order

cpdef int gcd(int a, int b):
    if a == 0:
        return abs(b)
    if b == 0:
        return abs(a)
    cdef int za = trailing_zeros(a)
    cdef int zb = trailing_zeros(b)
    cdef unsigned int k = min(za, zb)
    cdef unsigned int u,v
    u = abs(a >> za)
    v = abs(b >> zb)

    while u != v:
        if u > v:
            u, v = v, u
        v -= u
        v >> trailing_zeros(v)

    r = u << k
    return r