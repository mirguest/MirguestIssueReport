HEPMCHOME=/home/ihep/local
all: dicto
	g++ -fPIC -shared -o libHepMCDict.so HepMCDict.o \
		-L${HEPMCHOME}/lib -lHepMC `root-config --libs`

dicto: dict
	g++ -fPIC -c HepMCDict.cxx `root-config --cflags` -I${HEPMCHOME}/include

dict: hepmc_linkdef.h
	rootcint -f HepMCDict.cxx -c -p -I${HEPMCHOME}/include \
		${HEPMCHOME}/include/HepMC/*.h \
		hepmc_linkdef.h
