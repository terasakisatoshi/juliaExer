JL_SHARE = $(shell julia -e 'print(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia"))')
CFLAGS   += $(shell $(JL_SHARE)/julia-config.jl --cflags)
CXXFLAGS += $(shell $(JL_SHARE)/julia-config.jl --cflags)
LDFLAGS  += $(shell $(JL_SHARE)/julia-config.jl --ldflags)
LDLIBS   += $(shell $(JL_SHARE)/julia-config.jl --ldlibs)

TARGET_NAME=test
C_PROGRAM_FILE=test.c

all: run

embed_example: $(C_PROGRAM_FILE)
	gcc $< -o $(TARGET_NAME) $(CFLAGS) $(LDFLAGS) $(LDLIBS)

run: embed_example
	./$(TARGET_NAME)

clean:
	rm -f ./$(TARGET_NAME)
