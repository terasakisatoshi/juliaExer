# auto diff from scratch

"""
Reference:
https://www.juliabox.com/notebook/notebooks/tutorials/intro-to-julia/AutoDiff.ipynb
http://hplgit.github.io/primer.html/doc/pub/class/._class-readable005.html
https://docs.python.jp/3/reference/datamodel.html#object.__radd__
https://docs.python.org/3/whatsnew/3.5.html#pep-485-a-function-for-testing-approximate-equality
https://docs.python.jp/3/library/operator.html#module-operator
https://www.physicsforums.com/threads/derivative-of-f-x-to-the-power-of-g-x-and-algebra-problem.273333/
"""

import numbers
import math


def Babylonian(x, N=10):
    """
    t=sqrt(x)
    """
    t = (1 + x) / 2
    for i in range(2, N + 1):
        t = (t + x / t) / 2
    return t


class D(object):

    def __init__(f, x, d=1):
        f.x = x
        f.d = d

    def __call__(f):
        return f.x

    def __add__(f, g):  # define f+g
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return D(f.x + g.x, f.d + g.d)

    def __radd__(f, g):        # defines g+f
        return f + g

    def __sub__(f, g):  # define f-g
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return D(f.x - g.x, f.d - g.d)

    def __rsub__(f, g):  # define f-g
        return f - g

    def __mul__(f, g):  # define f*g
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return D(f.x * g.x, f.x * g.d + f.d * g.x)

    def __rmul__(f, g):  # define f*g
        return f * g

    def __truediv__(f, g):  # define f/g
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return D(f.x / g.x, (f.d * g.x - f.x * g.d) / g.x / g.x)

    def __rtruediv__(f, g):
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return g / f

    def __neg__(f):
        return D(-f.x, -f.d)  # define -f

    def __pow__(f, g):  # define f**g
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return D(f.x**g.x, f.x**g.x * (g.d * math.log(f.x) + g.x * f.d / f.x))

    def __rpow__(f, g):  # define g**f
        if isinstance(g, numbers.Number):
            g = D(g, 0)
        return g**f

    def __repr__(f):
        return ("x = {}, f' = {}".format(f.x, f.d))


def d(f, x=None):

    if x:
        return f(D(x)).d  # return f'(x)
    else:
        return lambda x: f(D(x)).d  # return function f'


def main():
    x = 3
    assert math.isclose(Babylonian(3), x**0.5)
    print(D(x), -D(x))
    print(2 * D(x))
    print(1 / D(x))
    assert math.isclose((1 / D(x)).d, -1 / x / x)
    print(D(x) * 2)
    print(D(x) / 2)
    print(D(x)**2)
    assert math.isclose((D(x) / D(x + 1)).d, 1 / (x + 1) / (x + 1))
    assert math.isclose((D(x)**2).d, 2 * x)
    print(2**D(x))
    assert math.isclose((2**D(x)).d, math.log(2) * 2**x)
    f = Babylonian
    print(f(x), d(f, x))
    assert math.isclose(f(x), x**0.5)
    assert math.isclose(d(f, x), x**(-0.5) / 2)
    assert math.isclose(d(f)(x), x**(-0.5) / 2)


if __name__ == '__main__':
    main()
