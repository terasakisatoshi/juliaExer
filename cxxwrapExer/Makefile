libhello.so: hello.cpp
	g++ -std=c++14 -shared -fPIC -o $@ $^ \
	-I $(HOME)/.julia/packages/CxxWrap/Ho7vF/deps/usr/include \
	-I $(HOME)/julia/include/julia \
	-DJULIA_ENABLE_THREADING=1 \
	-DJulia_EXECUTABLE=/home/terasaki/julia/bin/julia \
	-DBUILD_JULIA=ON

clean: 
	rm -f libhello.so