
all: libmain myapp

libmain: main.cpp
	g++ -fPIC -shared -o libmain.so main.cpp

myapp: libmain MyApp.h MyApp.cpp
	g++ -o myapp MyApp.cpp -L. -lmain -Wl,-rpath=.
