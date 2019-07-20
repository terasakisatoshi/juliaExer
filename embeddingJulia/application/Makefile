JL_SHARE = $(shell julia -e 'print(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia"))')
CFLAGS   += $(shell $(JL_SHARE)/julia-config.jl --cflags)
CXXFLAGS += $(shell $(JL_SHARE)/julia-config.jl --cflags)
LDFLAGS  += $(shell $(JL_SHARE)/julia-config.jl --ldflags)
LDLIBS   += $(shell $(JL_SHARE)/julia-config.jl --ldlibs)

TARGET_NAME=jl_application
C_PROGRAM_FILE=jl_application.c

all: run

shared_example: $(C_PROGRAM_FILE)
	gcc $< -o $(TARGET_NAME).dylib -O2 -shared -fPIC $(CFLAGS) $(LDFLAGS) $(LDLIBS)

run: shared_example
	python call_shared_from.py

clean:
	rm -f ./$(TARGET_NAME).dylib
