
name := TestExtGenerator
G4TARGET := $(name)
G4EXLIB := true

EXTRA_LINK_DEPENDENCIES := libExtGenerator.so

.PHONY: all
all: bin lib

include $(G4INSTALL)/config/architecture.gmk
#include $(G4INSTALL)/config/common.gmk
include $(G4INSTALL)/config/binmake.gmk


CPPFLAGS += -I ../include/ -I ./include
EXTRALIBS += -L$(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator -lExtGenerator
EXTRALIBS += -Wl,-rpath $(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator
LDLIBS += -L$(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator -lExtGenerator
LDLIBS += -Wl,-rpath $(G4WORKDIR)/tmp/$(G4SYSTEM)/ExtGenerator

libExtGenerator.so: 
	@echo Compling libExtGenerator.so
	cd ../; $(MAKE)

