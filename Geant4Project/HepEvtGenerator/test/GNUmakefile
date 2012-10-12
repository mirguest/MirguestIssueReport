
name := TestExtGenerator
G4TARGET := $(name)
G4EXLIB := true

.PHONY: all
all: bin lib

include $(G4INSTALL)/config/architecture.gmk
#include $(G4INSTALL)/config/common.gmk
include $(G4INSTALL)/config/binmake.gmk

EXTRA_LINK_DEPENDENCIES := libExtGenerator.so

CPPFLAGS += -I ../include/ -I ./include
EXTRALIBS += -L$(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator -lExtGenerator
EXTRALIBS += -Wl,-rpath $(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator
LDLIBS += -L$(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator -lExtGenerator
LDLIBS += -Wl,-rpath $(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator

libExtGenerator.so:
	cd ../; $(MAKE)
