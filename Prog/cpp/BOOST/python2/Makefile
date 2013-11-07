all: base svc

base: basebind.o base.o
	g++ -fPIC -shared -o base.so basebind.o base.o `pkg-config --libs python` -lboost_python
basebind.o: base.o basebind.cc
	g++ -fPIC -c basebind.cc `pkg-config --cflags python`
base.o: interface.h svcbase.h 
	g++ -fPIC -c base.cc

svc: svcbind.o svcimpl.o base
	g++ -fPIC -shared -o svc.so base.so svcbind.o svcimpl.o `pkg-config --libs python` -lboost_python
svcbind.o: svcimpl.o svcbind.cc
	g++ -fPIC -c svcbind.cc `pkg-config --cflags python`
svcimpl.o: interface.h svcbase.h svcimpl.cc svcimpl.h 
	g++ -fPIC -c svcimpl.cc
