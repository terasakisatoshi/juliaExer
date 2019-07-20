# solve eq x=cos(x)
from math import cos


def main():
    x = 0.0
    eps = 1e-7
    itertion = 1000000
    is_convergence = False

    for i in range(itertion):
        xnext = cos(x)
        if(abs(xnext-x) < eps):
            is_convergence = True
            break
        x = xnext

    if is_convergence:
        print("X=", xnext, ", iter=", i+1)
        print("X-cos(X)=", xnext-cos(xnext))
    else:
        print("No Convergence")

if __name__ == '__main__':
    main()
