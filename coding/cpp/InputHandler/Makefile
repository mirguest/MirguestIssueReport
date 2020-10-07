
all: libs main

main: main.o libs
	g++ -o main.exe main.o -Wl,-rpath=. -L. -lInputHandler

libs: libInputHandler.so

libInputHandler.so: SingleInputHandler.o
	g++ -shared -o $@ $^

main.o: main.cc
SingleInputHandler.o: SingleInputHandler.h SingleInputHandler.cc

%.o: %.cc
	g++ -fPIC -c $< -o $@
