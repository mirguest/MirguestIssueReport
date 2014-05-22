#!/bin/bash

# This is for boss specific libraries
# Used by install-all.sh

# install GEANT4
# NOTE: we use the modified version of geant4!
## install CLHEP 
## install GEANT4
## install GDML

function install-geant4-clhep-package-version {
    echo 2.0.4.5
}
function install-geant4-clhep-package-name {
    echo clhep-2.0.4.5.tgz
}
function install-geant4-clhep-download-url {
    echo http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.0.4.5.tgz
}
function install-geant4-clhep-install-prefix {
    echo $EXTERNALLIBDIR/external/clhep/2.0.4.5/$CMTCONFIG
}
function install-geant4-clhep {
    echo $FUNCNAME  
    if [ ! -f "$DOWNLOADDIR/$(install-geant4-clhep-package-name)" ];
    then
        pushd $DOWNLOADDIR
        wget $(install-geant4-clhep-download-url)
        popd 
    fi

    pushd $DOWNLOADDIR
    if [ ! -d "2.0.4.5" ];
    then
        tar zxvf $(install-geant4-clhep-package-name)
    fi

    pushd 2.0.4.5/CLHEP/
    if [ ! -d "$(install-geant4-clhep-install-prefix)" ];
    then
        mkdir -p $(install-geant4-clhep-install-prefix)
    fi
    ./configure --prefix=$(install-geant4-clhep-install-prefix)
    make
    make install
    popd
    popd

}

## install geant4
function install-geant4-geant4-install-prefix {
    echo $EXTERNALLIBDIR/external/geant4/4.9.3p01/$CMTCONFIG
}
function install-geant4-geant4-source-dir {
    echo geant4.9.3p01
}

function install-geant4-geant4-source-copy-from {
    local t=${1:-no} # indicate afs or not
    local prefix=$DOWNLOADDIR/packages
    if [ "$t" = "yes" ]; then
        prefix=/afs/ihep.ac.cn/bes3/offline/ExternalLib/packages
    fi
    echo $prefix/geant4/4.9.3.p01/x86_64-slc5-gcc43-opt/geant4.9.3.p01
}
function install-geant4-geant4-env-setup {
    export G4SYSTEM="Linux-g++"
    export G4DEBUG=""
    export G4LIB_BUILD_SHARED="1"
    # FOR BUILDING
    export G4INSTALL="$DOWNLOADDIR/$(install-geant4-geant4-source-dir)"

    export CLHEP_native_version="$(install-geant4-clhep-package-version)"
    export CLHEP_BASE_DIR="$(install-geant4-clhep-install-prefix)"

    export G4VIS_USE="1"
    export G4VIS_USE_OPENGLX="1"
    export G4VIS_BUILD_OPENGLX_DRIVER="1"

    export G4LIB_BUILD_GDML="1"
    export XERCESCROOT=$EXTERNALLIBDIR/external/XercesC/$(install-XercesC-package-version)/$CMTCONFIG

}

function install-geant4-geant4-env {
    install-geant4-geant4-env-setup
    export G4INSTALL="$(install-geant4-geant4-install-prefix)"

    export LD_LIBRARY_PATH=$G4INSTALL/lib/$G4SYSTEM:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$CLHEP_BASE_DIR/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$XERCESCROOT/lib:$LD_LIBRARY_PATH

    export G4LEVELGAMMADATA=$G4INSTALL/data/PhotonEvaporation2.0
    export G4RADIOACTIVEDATA=$G4INSTALL/data/RadioactiveDecay3.2
    export G4LEDATA=$G4INSTALL/data/G4EMLOW6.9
    export G4NEUTRONHPDATA=$G4INSTALL/data/G4NDL3.13
    export G4ABLADATA=$G4INSTALL/data/G4ABLA3.0
    export G4REALSURFACEDATA=$G4INSTALL/data/RealSurface1.0

}
function install-geant4-geant4-to-prefix {
    if [ ! -d "$(install-geant4-geant4-install-prefix)" ];
    then
        mkdir -p $(install-geant4-geant4-install-prefix)
    fi
    pushd $(install-geant4-geant4-install-prefix)
    local sourcecodefrom=$DOWNLOADDIR/$(install-geant4-geant4-source-dir)
    rsync -avz $sourcecodefrom/config .
    rsync -avz $sourcecodefrom/ReleaseNotes .
    rsync -avz $sourcecodefrom/examples .
    rsync -avz $sourcecodefrom/source .
    rsync -avz $sourcecodefrom/environments .
    rsync -avz $sourcecodefrom/Configure .
    rsync -avz $sourcecodefrom/data .
    rsync -avz $sourcecodefrom/include .
    rsync -avz $sourcecodefrom/lib .
    popd

}
function install-geant4-geant4 {
    echo $FUNCNAME

    # sync data from old directory
    if [ ! -d "$DOWNLOADDIR/$(install-geant4-geant4-source-dir)" ];
    then 
            mkdir -p $DOWNLOADDIR/$(install-geant4-geant4-source-dir)
    fi
    pushd $DOWNLOADDIR/$(install-geant4-geant4-source-dir)
    local sourcecodefrom=$(install-geant4-geant4-source-copy-from)
    rsync -avz $sourcecodefrom/config .
    rsync -avz $sourcecodefrom/ReleaseNotes .
    rsync -avz $sourcecodefrom/examples .
    rsync -avz $sourcecodefrom/source .
    rsync -avz $sourcecodefrom/environments .
    rsync -avz $sourcecodefrom/Configure .
    rsync -avz $sourcecodefrom/data .

    install-geant4-geant4-env-setup

    pushd source
    make 
    make includes
    make global
    # run make the second time to creating libs.
    #make 
    popd

    install-geant4-geant4-to-prefix

    popd

}

# install GDML
function install-geant4-gdml-package-version {
    echo 2.8.0
}
function install-geant4-gdml-source-dir {
    echo BesGDML2.8.0
}
function install-geant4-gdml-install-prefix {
    echo $EXTERNALLIBDIR/external/BesGDML/$(install-geant4-gdml-package-version)/$CMTCONFIG
}

function install-geant4-gdml-source-copy-from {
    local t=${1:-no} # indicate afs or not
    local prefix=$DOWNLOADDIR/packages
    if [ "$t" = "yes" ]; then
        prefix=/afs/ihep.ac.cn/bes3/offline/ExternalLib/packages
    fi
    echo $prefix/BesGDML/2.8.0/x86_64-slc5-gcc43-opt/CPPGDML
}

function install-geant4-gdml-sync-from-src-to-download {
    if [ ! -d "$DOWNLOADDIR/$(install-geant4-gdml-source-dir)" ];
    then
        mkdir $DOWNLOADDIR/$(install-geant4-gdml-source-dir)
    fi
    pushd $DOWNLOADDIR/$(install-geant4-gdml-source-dir)
    local sourcecodefrom=$(install-geant4-gdml-source-copy-from)
    local entry=""
    local syncentries="aclocal.m4 ac.sh CERNConfigure.csh CERNConfigure.sh ChangeLog"
    syncentries="$syncentries Common config config.log config.status configure configure.in"
    syncentries="$syncentries Examples G4Binding GNUmakefile README ROOTBinding"
    syncentries="$syncentries SLACConfigure.sh STEPBinding"
    for entry in $syncentries
    do
        rsync -avz $sourcecodefrom/$entry .
    done 
    popd
}

function install-geant4-gdml-patch {
    pushd $DOWNLOADDIR/$(install-geant4-gdml-source-dir)
    patch -p0 << EOF
--- Common/Saxana/src/GDMLEntityResolver.cpp.orig       2014-03-28 19:21:57.000000001 +0800
+++ Common/Saxana/src/GDMLEntityResolver.cpp    2014-03-28 19:22:30.000000001 +0800
@@ -10,6 +10,7 @@
 #include <string>
 #include <stdlib.h>
 #include <unistd.h>
+#include <linux/limits.h>
 
 using namespace xercesc;
 using std::string;
EOF
    patch -p0 << EOF
--- GNUmakefile.orig    2010-11-17 15:04:51.000000001 +0800
+++ GNUmakefile 2014-03-30 19:45:43.000000001 +0800
@@ -122,7 +122,7 @@
        cp -vR \$(PROJECT_BUILD_AREA)/\$(PLATFORM)/bin/* \$(bindir)
 
 # install includes
-install_headers := \$(shell find . -name *.h)
+install_headers := \$(shell find . -name *.h -o -name *.hh)
 install_include:
        for i in \$(install_headers); do \\
                i_dir=`dirname $$i`; \\
EOF

    popd
}
function install-geant4-gdml-configure {
    pushd $DOWNLOADDIR/$(install-geant4-gdml-source-dir)
    ./configure --prefix=$(install-geant4-gdml-install-prefix) \
                                                    --with-xercesc=$XERCESCROOT \
                                                    --with-clhep=$CLHEP_BASE_DIR \
                                                    --with-geant4=$(install-geant4-geant4-install-prefix) \
                                                    --enable-geant4-granular-libs

    popd
}

function install-geant4-gdml {
    echo $FUNCNAME

    install-geant4-gdml-sync-from-src-to-download
    # setup geant4 environment 
    install-geant4-geant4-env
    install-ROOT-env
    # configure this package
install-geant4-gdml-configure
    # make and make install
    pushd $DOWNLOADDIR/$(install-geant4-gdml-source-dir)
    install-geant4-gdml-patch
    make 
    make install
    popd
}

# DIM: for DistBoss
function install-dim-package-version {
    echo v19r11
}

function install-dim-package-name {
    echo dim_$(install-dim-package-version).zip
}

function install-dim-download-url {
    echo http://dim.web.cern.ch/dim/$(install-dim-package-name)
}

function install-dim-install-prefix {
    echo $EXTERNALLIBDIR/external/DIM/dim_$(install-dim-package-version)/$CMTCONFIG
}

function install-dim-setup-env {
    export OS=Linux
    export DIMDIR=$DOWNLOADDIR/dim_$(install-dim-package-version)
    export ODIR=linux
    alias TestServer=$DIMDIR/$ODIR/testServer
    alias TestClient=$DIMDIR/$ODIR/testClient
    alias Test_server=$DIMDIR/$ODIR/test_server
    alias Test_client=$DIMDIR/$ODIR/test_client
    alias Dns=$DIMDIR/$ODIR/dns
    alias Dim_get_service=$DIMDIR/$ODIR/dim_get_service
    alias Dim_send_command=$DIMDIR/$ODIR/dim_send_command
    alias DimBridge=$DIMDIR/$ODIR/DimBridge
    alias Did=$DIMDIR/$ODIR/did
}

function install-dim-env {
    export OS=Linux
    export DIMDIR=$(install-dim-install-prefix)
    export ODIR=linux
    alias TestServer=$DIMDIR/$ODIR/testServer
    alias TestClient=$DIMDIR/$ODIR/testClient
    alias Test_server=$DIMDIR/$ODIR/test_server
    alias Test_client=$DIMDIR/$ODIR/test_client
    alias Dns=$DIMDIR/$ODIR/dns
    alias Dim_get_service=$DIMDIR/$ODIR/dim_get_service
    alias Dim_send_command=$DIMDIR/$ODIR/dim_send_command
    alias DimBridge=$DIMDIR/$ODIR/DimBridge
    alias Did=$DIMDIR/$ODIR/did

    export LD_LIBRARY_PATH=$DIMDIR/$ODIR:$LD_LIBRARY_PATH
}

function install-dim-sync-to-install {
    local installprefix=$(install-dim-install-prefix)
    if [ ! -d $installprefix ];
    then
            mkdir -p $installprefix
    fi
    # sync the whole directory
    rsync -avz dim $installprefix
    rsync -avz linux $installprefix --exclude "*.o"
}

function install-dim {
    echo $FUNCNAME
    if [ ! -f "$DOWNLOADDIR/$(install-dim-package-name)" ];
    then
        pushd $DOWNLOADDIR >& /dev/null
        wget $(install-dim-download-url)
        popd >& /dev/null
    fi

    pushd $DOWNLOADDIR >& /dev/null
    if [ ! -d "dim_$(install-dim-package-version)" ];
    then
        unzip $(install-dim-package-name)
    fi
    pushd dim_$(install-dim-package-version)
    install-dim-setup-env
    make clean
    make
    make
    install-dim-sync-to-install
    popd
    popd >& /dev/null

}

# XML-RPC 1.06.40@SLC5
# But it does not work very well @SLC6.
function install-xmlrpc-package-version {
    #echo 1.06.40
    echo 1.25.27
}
function install-xmlrpc-package-name {
    echo xmlrpc-c-$(install-xmlrpc-package-version).tgz
}

function install-xmlrpc-install-prefix {
    echo $EXTERNALLIBDIR/external/xmlrpc-c/xmlrpc-c-$(install-xmlrpc-package-version)/$CMTCONFIG
}
function install-xmlrpc-download-url {
    #echo downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.06.40/xmlrpc-c-1.06.40.tgz
    echo downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.25.27/$(install-xmlrpc-package-name)
}

function install-xmlrpc-configure {
    ./configure --prefix=$(install-xmlrpc-install-prefix)
}
function install-xmlrpc {
    echo $FUNCNAME
    if [ ! -f "$DOWNLOADDIR/$(install-xmlrpc-package-name)" ];
    then
        pushd $DOWNLOADDIR >& /dev/null
        wget $(install-xmlrpc-download-url)
        popd >& /dev/null
    fi
    pushd $DOWNLOADDIR >& /dev/null

    if [ ! -d "xmlrpc-c-$(install-xmlrpc-package-version)" ];
    then
        tar zxvf $(install-xmlrpc-package-name)
    fi

    pushd xmlrpc-c-$(install-xmlrpc-package-version)
    install-xmlrpc-configure
    make
    make install
    popd

    popd >& /dev/null
}

# install genbes
function install-genbes-version {
    echo genbes-00-00-11
}
function install-genbes-install-prefix {
    echo $EXTERNALLIBDIR/external/genbes/$(install-genbes-version)
}
function install-genbes-source-copy-from {
    local t=${1:-no} # indicate afs or not
    local prefix=$DOWNLOADDIR/packages
    if [ "$t" = "yes" ]; then
        prefix=/afs/ihep.ac.cn/bes3/offline/ExternalLib/packages
    fi
    echo $prefix/genbes/genbes-00-00-11
}
function install-genbes-sync-from-source-to-downdload {
    pushd $DOWNLOADDIR/genbes/$(install-genbes-version)
    local sourcecodefrom=$(install-genbes-source-copy-from)
    rsync -avz $sourcecodefrom/cmt .
    rsync -avz $sourcecodefrom/src .
    popd
}
function install-genbes-sync-from-download-to-install {
    if [ ! -d "$(install-genbes-install-prefix)" ];
    then
            mkdir -p $(install-genbes-install-prefix)
    fi
    pushd $(install-genbes-install-prefix)
    local sourcecodefrom=$DOWNLOADDIR/genbes/$(install-genbes-version)
    rsync -avz $sourcecodefrom/cmt .
    rsync -avz $sourcecodefrom/src .
    popd
}
function install-genbes-build-all-lib-setup-env {
    setup-boss
    local tmpcmtpath=$EXTERNALLIBDIR/external
    export CMTPATH=$tmpcmtpath:$CMTPATH
}
function install-genbes-build-all-lib {
    install-genbes-build-all-lib-setup-env
    pushd $(install-genbes-install-prefix)/cmt
    if [ ! -d $(install-genbes-install-prefix)/$CMTCONFIG ];
    then
        cmt config
    fi
    for pkg in $(grep ^library requirements | cut -d ' ' -f 2);
    do
        echo building $pkg
        make $pkg >& mylog.$pkg; 
    done
    popd
}

function install-genbes {
    echo $FUNCNAME
    if [ ! -d "$DOWNLOADDIR/genbes/$(install-genbes-version)" ];
    then
        mkdir -p $DOWNLOADDIR/genbes/$(install-genbes-version)
    fi

    pushd $DOWNLOADDIR/genbes/$(install-genbes-version)
    # sync data first
    install-genbes-sync-from-source-to-downdload 
    install-genbes-sync-from-download-to-install 
    # builing the library
    #install-genbes-build-all-lib
    popd
}

# install BESCLHEP-Alist and BESCLHEP-String
function install-BESCLHEP-Alist-version {
    echo Alist-00-00-06
}
function install-BESCLHEP-String-version {
    echo String-00-00-05
}

## install prefix
function install-BESCLHEP-XXX-install-prefix {
    local pkg=$1
    local ver=$(install-BESCLHEP-$pkg-version)
    echo $EXTERNALLIBDIR/external/CLHEP/$pkg/$ver
}
function install-BESCLHEP-Alist-install-prefix {
    echo $(install-BESCLHEP-XXX-install-prefix Alist)
}
function install-BESCLHEP-String-install-prefix {
    echo $(install-BESCLHEP-XXX-install-prefix String)
}
## copy from
function install-BESCLHEP-XXX-source-copy-from {
    local pkg=$1
    local ver=$(install-BESCLHEP-$pkg-version)
    local t=${2:-no} # indicate afs or not
    local prefix=$DOWNLOADDIR/packages
    if [ "$t" = "yes" ]; then
        prefix=/afs/ihep.ac.cn/bes3/offline/ExternalLib/packages
    fi
    echo $prefix/CLHEP/$pkg/$ver
}
function install-BESCLHEP-Alist-source-copy-from {
    local t=${1:-no} # indicate afs or not
    echo $(install-BESCLHEP-XXX-source-copy-from Alist $t)
}
function install-BESCLHEP-String-source-copy-from {
    local t=${1:-no} # indicate afs or not
    echo $(install-BESCLHEP-XXX-source-copy-from String $t)
}
function install-BESCLHEP-XXX {
    local pkg=${1:-Alist}
    if [ ! -d $(install-BESCLHEP-$pkg-install-prefix) ];
    then
        mkdir -p $(install-BESCLHEP-$pkg-install-prefix)
    fi
    # sync
    pushd $(install-BESCLHEP-$pkg-install-prefix)
    local sourcecodefrom=$(install-BESCLHEP-$pkg-source-copy-from)
    rsync -avz $sourcecodefrom/cmt .
    rsync -avz $sourcecodefrom/CLHEP .
    # building the code
    setup-boss
    local tmpcmtpath=$EXTERNALLIBDIR/external/CLHEP
    export CMTPATH=$tmpcmtpath:$CMTPATH
    pushd cmt
    cmt br cmt config
    source setup.sh
    cmt br cmt make
    popd
    popd

}

function install-BESCLHEP-Alist {
    install-BESCLHEP-XXX Alist
}
function install-BESCLHEP-String {
    install-BESCLHEP-XXX String
}

