
CPPFLAGS=-I${MONGOHOME}/include
LDFLAGS=-L${MONGOHOME}/lib -lmongoclient
LDFLAGS+=-lboost_thread -lboost_system -lboost_regex 

CPPFLAGS+=-I.

all: loadJson.exe queryTest.exe

loadJson.exe: loadJson.cc
	g++ -o loadJson.exe loadJson.cc ${CPPFLAGS} ${LDFLAGS}

queryTest.exe: test/queryTest.cc
	g++ -o queryTest.exe test/queryTest.cc ${CPPFLAGS} ${LDFLAGS}
