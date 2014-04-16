CPPFLAGS=-I. $(shell root-config --cflags)
LDFLAGS=$(shell root-config --libs) -Wl,--no-as-needed

all: libs main

main: main.o libs
	g++ -o main.exe main.o -Wl,-rpath=. -L. -lInputHandler ${LDFLAGS}

libs: libInputHandler.so

libInputHandler.so: InputHandler.o TestStream/NormalTest1Stream.o
	g++ -shared -o $@ $^ ${LDFLAGS}

main.o: main.cc
InputHandler.o: InputHandler.h InputHandler.cc
TestStream/NormalTest1Stream.o: TestStream/NormalTest1Stream.h TestStream/NormalTest1Stream.cc


%.o: %.cc
	g++ -fPIC ${CPPFLAGS} -c $< -o $@

clean:
	-rm main.exe main.o
	-rm libInputHandler.so
	-rm InputHandler.o
	-rm TestStream/NormalTest1Stream.o

.PHONY: clean
