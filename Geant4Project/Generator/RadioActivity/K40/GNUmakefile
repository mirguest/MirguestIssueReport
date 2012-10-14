
CC = g++
CCFLAGS += $(shell clhep-config --include)
LDFLAGS += $(shell clhep-config --libs)

SRCS = $(wildcard src/*.cc)
OBJS = $(SRCS:.cc=.o)

TARGET = K40

$(TARGET): $(OBJS)
	@$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.cc
	@$(CC) $(CCFLAGS) -c $< -o $@

clean:
	@-rm $(OBJS)

.PHONY:  clean
