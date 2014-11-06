
CPPFLAGS=-I${MONGOHOME}/include
LDFLAGS=-L${MONGOHOME}/lib -lmongoclient
LDFLAGS+=-lboost_thread -lboost_system -lboost_regex 

all: loadJson.exe

loadJson.exe: loadJson.cc
	g++ -o loadJson.exe loadJson.cc ${CPPFLAGS} ${LDFLAGS}
