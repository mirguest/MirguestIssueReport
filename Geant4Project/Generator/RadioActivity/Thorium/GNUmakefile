
F77 = gfortran
F77FLAGS += -ffixed-line-length-none -fPIC -fno-automatic 
LDFLAGS += $(shell cernlib pawlib mathlib)

SRCS = $(wildcard src/*.f)
OBJS = $(SRCS:.f=.o)

TARGET = Thorium

$(TARGET): $(OBJS)
	@$(F77) $(F77FLAGS) -o $@ $^ $(LDFLAGS)  

%.o: %.f
	@$(F77) $(F77FLAGS) -c $< -o $@

clean:
	@-rm $(OBJS)

.PHONY:  clean
