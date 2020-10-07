all: libMyHit.so

libMyHit.so: MyHit.cc MyHit.h MyHitDict.cc
	g++ -fPIC -shared -o libMyHit.so MyHit.cc MyHitDict.cc `root-config --cflags --libs`


MyHitDict.cc: MyHit.cc MyHit.h
	-rm MyHitDict.cc MyHitDict.h
	rootcint MyHitDict.cc -c MyHit.h
