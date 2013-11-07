all: base svc

base: basebind.o base.o
	g++ -fPIC -shared -rdynamic -Wl,--no-undefined -o base.so basebind.o base.o `pkg-config --libs python` -lboost_python -ldl
basebind.o: base.o basebind.cc
	g++ -fPIC -c basebind.cc `pkg-config --cflags python`
base.o: interface.h svcbase.h 
	g++ -fPIC -c base.cc

svc: svcbind.o svcimpl.o base
	g++ -fPIC -shared -rdynamic -Wl,--no-undefined -o svc.so svcbind.o svcimpl.o base.so -lgc  `pkg-config --libs python` -lboost_python -ldl
svcbind.o: svcimpl.o svcbind.cc
	g++ -fPIC -c svcbind.cc `pkg-config --cflags python`
svcimpl.o: interface.h svcbase.h svcimpl.cc svcimpl.h 
	g++ -fPIC -c svcimpl.cc
