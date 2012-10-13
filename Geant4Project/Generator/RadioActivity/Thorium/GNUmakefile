
F77 = gfortran

LDFLAGS += $(shell cernlib pawlib)

SRCS = $(wildcard src/*.f)
OBJS = $(SRCS:.f=.o)

TARGET = Thorium

$(TARGET): $(OBJS)
	$(F77) -o $@ $^ $(LDFLAGS)  

%.o: %.f
	$(F77) -c $< -o $@

clean:
	@-rm $(OBJS)

.PHONY:  clean
