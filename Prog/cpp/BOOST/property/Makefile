
all: libs test

libs: libProperty myproperty libDummy

libProperty: Property.hh Property.cc PropertyManager.hh PropertyManager.cc HelperParse.hh HelperParse.cc
	g++ -fPIC -c -I. Property.cc
	g++ -fPIC -c -I. PropertyManager.cc
	g++ -fPIC -c -I. HelperParse.cc
	g++ -fPIC -shared -o libProperty.so Property.o PropertyManager.o HelperParse.o

libDummy: dummy.hh dummy.cc
	g++ -fPIC -c -I. dummy.cc `pkg-config --cflags python`
	g++ -fPIC -shared -o libDummy.so dummy.o

myproperty: libProperty libDummy exportProperty.cc
	g++ -fPIC -c -I. exportProperty.cc `pkg-config --cflags python`
	g++ -fPIC -shared -o myproperty.so exportProperty.o -L. -lProperty -lDummy -lboost_python `pkg-config --libs python`

test: libs testProperty.cc 
	g++ -fPIC -c -I. testProperty.cc
	g++ -fPIC -o testProperty testProperty.o -L. -lProperty
