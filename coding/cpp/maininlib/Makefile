
all: libmain.so myapp myapp2

libmain.so: main.cpp
	g++ -fPIC -shared -o libmain.so main.cpp

myapp: MyApp.cpp | libmain.so
	g++ -o $@ $< -L. -lmain -Wl,-rpath=.

myapp2: MyApp2.cpp | libmain.so
	g++ -o $@ $< -L. -lmain -Wl,-rpath=.

MyApp.cpp: MyApp.h 
MyApp2.cpp: MyApp2.h
