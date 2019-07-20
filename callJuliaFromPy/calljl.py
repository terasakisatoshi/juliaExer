import numpy as np


def main():
    from julia import Julia
    julia = Julia()
    julia.eval("@eval Main import Base.MainInclude: include")
    from julia import Main
    Main.include("test.jl")

    arr = np.array([1, 2, 3])
    ret = Main.twice_array(arr)

    print("arr=", arr)
    print("ret=", ret)

    jlsin = Main.sin
    Main.rad45degree = np.pi / 4
    print(jlsin(Main.rad45degree), np.sqrt(2) / 2)


if __name__ == '__main__':
    main()
