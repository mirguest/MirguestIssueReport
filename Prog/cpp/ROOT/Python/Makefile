all: Hello.h Hello.cc
	@genreflex Hello.h
	@g++ -o libhello.so -shared Hello.cc Hello*.cpp `root-config --cflags --libs`
