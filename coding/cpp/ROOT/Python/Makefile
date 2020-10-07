all: Hello.h Hello.cc
	@genreflex Hello.h --rootmap=hello.rootmap --rootmap-lib=libhello
	@g++ -fPIC -o libhello.so -shared Hello.cc Hello*.cpp `root-config --cflags --libs`
