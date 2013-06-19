
all: property.cc property.hh dummy.hh dummy.cc PropertyManager.hh PropertyManager.cc
	g++ -fPIC -c property.cc `pkg-config --cflags python`
	g++ -fPIC -c dummy.cc `pkg-config --cflags python`
	g++ -fPIC -c PropertyManager.cc `pkg-config --cflags python`
	g++ -fPIC -shared -o hello.so dummy.o property.o PropertyManager.o -lboost_python `pkg-config --libs python`
