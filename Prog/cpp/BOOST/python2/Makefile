svc: svcbind.o svcimpl.o
	g++ -fPIC -shared -o svc.so svcbind.o svcimpl.o `pkg-config --libs python` -lboost_python

svcbind.o: svcimpl.o svcbind.cc
	g++ -fPIC -c svcbind.cc `pkg-config --cflags python`
svcimpl.o: interface.h svcbase.h svcimpl.cc svcimpl.h 
	g++ -fPIC -c svcimpl.cc
