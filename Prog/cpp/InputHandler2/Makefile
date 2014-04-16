CPPFLAGS=-I.

all: libs main

main: main.o libs
	g++ -o main.exe main.o -Wl,-rpath=. -L. -lInputHandler

libs: libInputHandler.so

libInputHandler.so: InputHandler.o TestStream/NormalTest1Stream.o
	g++ -shared -o $@ $^

main.o: main.cc
InputHandler.o: InputHandler.h InputHandler.cc
TestStream/NormalTest1Stream.o: TestStream/NormalTest1Stream.h TestStream/NormalTest1Stream.cc


%.o: %.cc
	g++ -fPIC ${CPPFLAGS} -c $< -o $@
