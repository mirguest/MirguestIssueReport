
CC = g++
CCFLAGS += $(shell clhep-config --include) $(shell root-config --cflags)
LDFLAGS += $(shell clhep-config --libs) $(shell root-config --libs)

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
