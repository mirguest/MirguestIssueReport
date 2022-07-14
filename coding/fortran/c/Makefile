main: main.o myimplementation.o myinterface.o
	g++ -o main main.o myimplementation.o myinterface.o -lgfortran

main.o: main.cc myinterface.h
	g++ -c main.cc

myinterface.o: myinterface.c myinterface.h
	g++ -c myinterface.c

myimplementation.o: myimplementation.f90
	gfortran -c myimplementation.f90
