
CPPFLAGS=-I${MONGOHOME}/include
LDFLAGS=-L${MONGOHOME}/lib -lmongoclient
LDFLAGS+=-lboost_thread -lboost_system -lboost_regex 
LDFLAGS+=-Wl,-rpath=.

all: bson2sql

bson2sql.exe: bson2sql.cc
	g++ -o bson2sql.exe bson2sql.cc ${CPPFLAGS} ${LDFLAGS}
