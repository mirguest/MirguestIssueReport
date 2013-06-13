
all: libs test

libs: Property.hh

test: libs testProperty.cc 
	g++ -c -I. testProperty.cc
	g++ -o testProperty testProperty.o
