import time

import numpy as np
from julia import Julia
julia = Julia()
julia.eval("@eval Main import Base.MainInclude: include")
from julia import Main


def main():
    Main.include("napier.jl")
    for _ in range(10):
        start = time.time()
        Main.count_upto_one()
        end = time.time()
        print(end - start)

if __name__ == '__main__':
    main()
