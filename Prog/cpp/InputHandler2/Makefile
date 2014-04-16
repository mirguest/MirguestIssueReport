
all: libs main

main: main.o libs
	g++ -o main.exe main.o -Wl,-rpath=. -L. -lInputHandler

libs: libInputHandler.so

libInputHandler.so: InputHandler.o
	g++ -shared -o $@ $^

main.o: main.cc
InputHandler.o: InputHandler.h InputHandler.cc

%.o: %.cc
	g++ -fPIC -c $< -o $@
