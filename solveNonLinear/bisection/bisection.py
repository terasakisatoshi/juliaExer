from math import cos


def func(x):
    return x-cos(x)


def bisection(func, x_left, x_right, eps):
    y_left = func(x_left)
    y_right = func(x_right)
    num_iter = 0
    iteration = 100000000
    if y_left == 0:
        return x_left, num_iter
    elif y_right == 0:
        return x_right, num_iter
    elif y_left*y_right > 0:
        return None, None
    else:
        for n in range(iteration):
            x_mid = (x_left+x_right)/2
            y_mid = func(x_mid)
            if y_mid == 0:
                num_iter = n
                return x_mid, num_iter
            if y_left*y_mid < 0:
                x_right = x_mid
            else:
                x_left = x_mid
            if(abs(x_right-x_left) < eps):
                num_iter = n
                return x_mid, num_iter
        return None, num_iter


def main():
    x_left, x_right = 0, 3.14
    eps = 1e-7
    solution, num_iter = bisection(func, x_left, x_right, eps)
    if solution is not None:
        print("X= ", solution, func(solution), num_iter)
    elif num_iter is None:
        print("f(x1)*f(x2) must be less than 0")
    else:
        print("No Convergence")


if __name__ == '__main__':
    main()
