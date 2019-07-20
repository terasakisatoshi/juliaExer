JL_SHARE = $(shell julia -e 'print(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia"))')
CFLAGS   += $(shell $(JL_SHARE)/julia-config.jl --cflags)
CXXFLAGS += $(shell $(JL_SHARE)/julia-config.jl --cflags)
LDFLAGS  += $(shell $(JL_SHARE)/julia-config.jl --ldflags)
LDLIBS   += $(shell $(JL_SHARE)/julia-config.jl --ldlibs)

TARGET_NAME=call_julia_from
C_PROGRAM_FILE=call_julia_from.c

all: run

embed_example: $(C_PROGRAM_FILE)
	gcc $< -o $(TARGET_NAME) $(CFLAGS) $(LDFLAGS) $(LDLIBS)

shared_example: shared_julia.c
	gcc $< -o $(TARGET_NAME).dylib -shared -fPIC $(CFLAGS) $(LDFLAGS) $(LDLIBS)


run: embed_example shared_example
	./$(TARGET_NAME)
	python call_shared_from.py

clean:
	rm -f ./$(TARGET_NAME)
	rm -f ./$(TARGET_NAME).dylib
