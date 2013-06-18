
all: property.cc property.hh
	g++ -fPIC -c property.cc `pkg-config --cflags python`
	g++ -fPIC -shared -o hello.so property.o -lboost_python `pkg-config --libs python`
