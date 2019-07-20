import os
from ctypes import cdll 

def main():
    shared_dll=cdll.LoadLibrary("call_julia_from.dylib")
    shared_dll.echo()
    shared_dll.initialize()
    shared_dll.evaluate_julia_scripts()
    shared_dll.finalize()


if __name__ == '__main__':
	main()
