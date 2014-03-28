#!/bin/bash
# This is for BES3 offline software
# setup the gaudi environment
# Requirements:
# * SLC 6
# * gcc 4.6
# * LCGCMT 65a
# * Gaudi v23r9
export DEVROOT=/afs/.ihep.ac.cn/bes3/offline/slc6/maqm-test-gcc46
export DOWNLOADDIR=$DEVROOT/download
export EXTERNALLIBDIR=$DEVROOT/ExternalLib
export CONTRIBDIR=$DEVROOT/contrib
export CMTCONFIG=x86_64-slc6-gcc46-opt
export BOSSDIR=$DEVROOT/boss

if [ ! -d $DOWNLOADDIR ];
then
  mkdir -p $DOWNLOADDIR
fi

# GCC

function install-gcc-package-name() {
  echo gcc_4.6.3__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-gcc-download-url() {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/gcc_4.6.3__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-gcc-real() {
  echo $FUNCNAME  
  if [ ! -f "$DOWNLOADDIR/$(install-gcc-package-name)" ];
  then
    pushd $DOWNLOADDIR
    wget $(install-gcc-download-url)
    popd 
  fi

  pushd $DOWNLOADDIR
  # tar zxvf
  if [ ! -d "gcc" ];
  then
    tar zxvf $(install-gcc-package-name)
  fi 
  if [ ! -d "$DEVROOT/contrib/gcc" ];
  then
    mv gcc $DEVROOT/contrib
  fi
  popd
}
function install-gcc() {
  pushd $DEVROOT
  if [ ! -d $DEVROOT/contrib ];
  then
    mkdir $DEVROOT/contrib
  fi
  pushd contrib
  if [ ! -d gcc ]; 
  then
    install-gcc-real
  fi

  popd
}
function setup-gcc() {
  export PATH=$DEVROOT/contrib/gcc/4.6.3/x86_64-slc6/bin:$PATH
  export LD_LIBRARY_PATH=$DEVROOT/contrib/gcc/4.6.3/x86_64-slc6/lib:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$DEVROOT/contrib/gcc/4.6.3/x86_64-slc6/lib64:$LD_LIBRARY_PATH
}

# CMT
function install-cmt-package-name() {
  echo CMTv1r25.tar.gz
}

function install-cmt-download-url() {
  echo ftp://ftp.utexas.edu/pub/gentoo/distfiles/CMTv1r25.tar.gz
}

function cmt-path { 
  echo $DEVROOT/contrib/CMT
}
function cmt-version {
  echo v1r25
}
function cmt-mgr-path {
  echo $(cmt-path)/$(cmt-version)/mgr
}
function install-cmt-make {
 pushd $(cmt-mgr-path)
 ./INSTALL
 source setup.sh
 make
 popd
}
function install-cmt-real() {
  echo $FUNCNAME  
  if [ ! -f "$DOWNLOADDIR/$(install-cmt-package-name)" ];
  then   
    pushd $DOWNLOADDIR
    wget $(install-cmt-download-url)
    popd 
  fi
                                   
  pushd $DOWNLOADDIR
  # tar zxvf
  if [ ! -d "cmt" ];
  then 
    tar zxvf $(install-cmt-package-name) 
  fi 
  if [ ! -d "$DEVROOT/contrib/CMT" ];
  then
    cp -r CMT $DEVROOT/contrib
  fi
  install-cmt-make
  popd 
  
}   
function install-cmt() {
  setup-gcc
  pushd $DEVROOT
  if [ ! -d $DEVROOT/contrib ];
  then
    mkdir $DEVROOT/contrib
  fi
  pushd contrib
  if [ ! -d CMT ];
  then
    install-cmt-real
  fi
  cd 
  popd
}
function setup-cmt() {
  setup-gcc
  pushd $(cmt-mgr-path)
  source setup.sh
  popd
}

# LCG
function lcg-version {
  echo LCGCMT_65a
}
function install-lcg-package-name() {
  echo LCGCMT_65a.tar.gz
}
function install-lcg-download-url() {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/LCGCMT_65a.tar.gz
}

function install-lcg-patch-lcg-settings {
cat << EOF > bespatch/lcg-settings.patch
--- LCGCMT_65a/LCG_Settings/cmt/requirements	2014-03-07 20:24:47.000000001 +0800
+++ LCGCMT_65a/LCG_Settings/cmt/requirements	2014-03-07 20:29:25.000000001 +0800
@@ -3,11 +3,13 @@
 
 include_path none
 
-macro LCG_releases    "\$(LCG_Settings_root)/../../.." \\
+#macro LCG_releases    "\$(LCG_Settings_root)/../../.." \\
+macro LCG_releases    "\${EXTERNALLIBDIR}/external" \\
       ATLAS&NIGHTLIES "/afs/cern.ch/sw/lcg/app/nightlies/\$(LCG_NGT_SLT_NAME)/\$(LCG_NGT_DAY_NAME)" \\
       ATLAS           "\${SITEROOT}/sw/lcg/app/releases"
 
-macro LCG_external  "\$(LCG_Settings_root)/../../../../../external" \\
+#macro LCG_external  "\$(LCG_Settings_root)/../../../../../external" \\
+macro LCG_external  "\${EXTERNALLIBDIR}/external" \\
       target-gcc48  "\$(LCG_Settings_root)/../../../../../experimental" \\
       ATLAS         "\${SITEROOT}/sw/lcg/external"

EOF
patch -p0  < $EXTERNALLIBDIR/LCGCMT/bespatch/lcg-settings.patch
}
function install-lcg-patch {
	pushd $EXTERNALLIBDIR/LCGCMT
	# AT THE TOP TREE
	if [ ! -d "bespatch" ];
	then
		mkdir bespatch
	fi
	install-lcg-patch-lcg-settings

	popd
}

function install-lcg-real() {
  echo $FUNCNAME  
  if [ ! -f "$DOWNLOADDIR/$(install-lcg-package-name)" ];
  then
    pushd $DOWNLOADDIR
    wget $(install-lcg-download-url)
    popd
  fi
  pushd $DOWNLOADDIR
  # tar zxvf
  if [ ! -d "LCGCMT" ];
  then
    tar zxvf $(install-lcg-package-name)
  fi
  if [ ! -d "$EXTERNALLIBDIR/LCGCMT" ];
  then
    cp -r LCGCMT $EXTERNALLIBDIR/
  fi
	install-lcg-patch
  popd
}
function install-lcg {
  setup-cmt
  pushd $DEVROOT
  if [ ! -d $EXTERNALLIBDIR ];
  then
    mkdir $EXTERNALLIBDIR
  fi
  pushd $EXTERNALLIBDIR
  if [ ! -d LCGCMT ];
  then
    install-lcg-real
  fi
  popd
}
function setup-lcg {
  setup-cmt
  export CMTPATH=$EXTERNALLIBDIR/LCGCMT/$(lcg-version)
}

#make lcg
function lcg-make {
  pushd $EXTERNALLIBDIR/LCGCMT/$(lcg-version)
  cd LCG_Release/cmt
  cmt br cmt config
  source setup.sh
  cmt br cmt make
  popd
}
  
#get Gaudi
function install-gaudi-download {
	pushd $EXTERNALLIBDIR
	if [ ! -d "gaudi" ]; 
	then
		git clone http://git.cern.ch/pub/gaudi
		cd gaudi
		git checkout -b GAUDI_v23r9 remotes/origin/svn/tags/GAUDI_v23r9
	fi
	popd 
}

function setup-gaudi {
  setup-lcg
  export CMTPATH=$EXTERNALLIBDIR/gaudi:${CMTPATH}
}
#gaudi external libs
#get python
function install-python-package-name() {
  echo Python_2.7.3__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-python-download-url() {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/Python_2.7.3__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-python {
  echo $FUNCNAME  
  if [ ! -f "$DOWNLOADDIR/$(install-python-package-name)" ];
  then
    pushd $DOWNLOADDIR
    wget $(install-python-download-url)
    popd 
  fi

  pushd $DOWNLOADDIR
  # tar zxvf
  if [ ! -d "Python" ];
  then
    tar zxvf $(install-python-package-name)
  fi 
  if [ ! -d "$EXTERNALLIBDIR/external/Python" ];
  then
    mv Python $EXTERNALLIBDIR/external
  fi
  popd

}

# helper
function install-PKG {
  local pkgname=$1
  echo $FUNCNAME  
  if [ ! -f "$DOWNLOADDIR/$(install-$pkgname-package-name)" ];
  then
    pushd $DOWNLOADDIR
    wget $(install-$pkgname-download-url)
    popd 
  fi

  pushd $DOWNLOADDIR
  # tar zxvf
  if [ ! -d "$pkgname" ];
  then
    tar zxvf $(install-$pkgname-package-name)
  fi 
  if [ ! -d "$EXTERNALLIBDIR/external/$pkgname" ];
  then
    mv $pkgname $EXTERNALLIBDIR/external
  fi
  popd
}

function install-HepPDT-package-name() {
  echo HepPDT_2.06.01__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-HepPDT-download-url() {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/HepPDT_2.06.01__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-HepPDT {
  install-PKG HepPDT
}
# RELAX
function install-RELAX-package-name() {
  echo RELAX_1_3_0m__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-RELAX-download-url() {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/RELAX_1_3_0m__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-RELAX {
  install-PKG RELAX
}

function install-ROOT-env {
	export ROOTSYS=$EXTERNALLIBDIR/external/ROOT/5.34.09/${CMTCONFIG}/root
	export PATH=$ROOTSYS/bin:$PATH
	export LD_LIBRARY_PATH=$ROOTSYS/lib/:$LD_LIBRARY_PATH
}

function install-ROOT-package-name {
  echo ROOT_5.34.09__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-ROOT-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/ROOT_5.34.09__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-ROOT {
  install-PKG ROOT
}

function install-GSL-package-name {
  echo GSL_1.10__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-GSL-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/GSL_1.10__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-GSL {
  install-PKG GSL
}

#install CASTOR
function install-castor-package-name {
  echo CASTOR_2.1.13-6__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-castor-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/CASTOR_2.1.13-6__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-CASTOR {
  install-PKG castor
}

function install-mysql-package-name {
  echo mysql_5.5.14__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-mysql-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/mysql_5.5.14__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-mysql {
  install-PKG mysql
}
function install-clhep-package-name {
  echo CLHEP_1.9.4.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-clhep-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/CLHEP_1.9.4.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-CLHEP {
  install-PKG clhep
}

# XercesC

function install-XercesC-package-version {
  echo 3.1.1p1
}

function install-XercesC-package-name {
  echo XercesC_3.1.1p1__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-XercesC-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/XercesC_3.1.1p1__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-XercesC {
  install-PKG XercesC
}

# uuid
function install-uuid-package-name {
  echo uuid_1.42__LCG_x86_64-slc5-gcc46-opt.tar.gz
}
function install-uuid-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/uuid_1.42__LCG_x86_64-slc5-gcc46-opt.tar.gz
}

function install-uuid {
  install-PKG uuid
}

# 
function install-AIDA-package-name {
  echo AIDA_3.2.1__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-AIDA-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/AIDA_3.2.1__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-AIDA {
  install-PKG AIDA
}

# 
function install-CppUnit-package-name {
  echo CppUnit_1.12.1_p1__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-CppUnit-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/CppUnit_1.12.1_p1__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-CppUnit {
  install-PKG CppUnit
}

function install-xrootd-package-name {
  echo xrootd_3.2.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-xrootd-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/xrootd_3.2.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-xrootd {
  install-PKG xrootd
}

function install-gccxml-package-name {
  echo GCCXML_0.9.0_20120309p2__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-gccxml-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/GCCXML_0.9.0_20120309p2__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-GCCXML {
  install-PKG gccxml
}

function install-libunwind-package-name {
  echo libunwind_5c2cade__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-libunwind-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/libunwind_5c2cade__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-libunwind {
  install-PKG libunwind
}

function install-tcmalloc-package-name {
  echo tcmalloc_1.7p3__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-tcmalloc-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/tcmalloc_1.7p3__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-tcmalloc {
  install-PKG tcmalloc
}
function install-pytools-package-name {
  echo pytools_1.8_python2.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-pytools-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/pytools_1.8_python2.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-pytools {
  install-PKG pytools
}

function install-Boost-package-name {
  echo Boost_1.50.0_python2.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-Boost-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/Boost_1.50.0_python2.7__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-Boost {
  install-PKG Boost
}

function install-HepMC-package-name {
	echo HepMC_2.06.08__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-HepMC-download-url {
	echo http://service-spi.web.cern.ch/service-spi/external/distribution/HepMC_2.06.08__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-HepMC {
	install-PKG HepMC
}

function install-cernlib-package-name {
	echo cernlib_2006a__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-cernlib-download-url {
	echo http://service-spi.web.cern.ch/service-spi/external/distribution/cernlib_2006a__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-cernlib {
	install-PKG cernlib
}

function install-lapack-package-name {
	echo lapack_3.4.0__LCG_x86_64-slc6-gcc46-opt.tar.gz
}
function install-lapack-download-url {
  echo http://service-spi.web.cern.ch/service-spi/external/distribution/lapack_3.4.0__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-lapack {
	install-PKG lapack
}

function install-blas-package-name {
	echo blas_20110419__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-blas-download-url {
	echo service-spi.web.cern.ch/service-spi/external/distribution/blas_20110419__LCG_x86_64-slc6-gcc46-opt.tar.gz
}

function install-blas {
	install-PKG blas
}

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
	echo /afs/ihep.ac.cn/bes3/offline/ExternalLib/packages/geant4/4.9.3.p01/x86_64-slc5-gcc43-opt/geant4.9.3.p01
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
	echo /afs/ihep.ac.cn/bes3/offline/ExternalLib/packages/BesGDML/2.8.0/x86_64-slc5-gcc43-opt/CPPGDML
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
	make 
	make install
	popd
}

#install boss
function boss-version() {
  echo 6.6.4
}
function BesRelease-version {
  echo BesRelease-01-02-22
}

function setup-cvs {
  export CVSROOT=':pserver:maqm@koala.ihep.ac.cn:/bes/bes'
	export CVSIGNORE='setup.* cleanup.* x86_64-slc5-gcc46* *.make Makefile Linux* *~ rh73_gcc32 i386* '
}
function checkout-boss {
	setup-cvs
  setup-boss
  if [ ! -d $BOSSDIR/$(boss-version) ];
	  then
		  mkdir $BOSSDIR/$(boss-version)
  fi
  cd $BOSSDIR/$(boss-version)
	cmt co -r $(BesRelease-version) BesRelease
	cmt co -requirements BesRelease/*/cmt/requirements
}

function setup-boss {
  setup-gaudi
	export SITEROOT=$DEVROOT
	export CMTCVSOFFSET="BossCvs"
  # Set boss area
	export BesArea=$BOSSDIR/$(boss-version)
	export CMTPATH=$BesArea:$CMTPATH
}

function install-external-all-contrib {
	install-gcc
	setup-gcc
	install-cmt
	setup-cmt
}

function install-external-all-lcg {
	local lcgpkg="python HepPDT RELAX ROOT GSL CASTOR mysql CLHEP"
	lcgpkg="$lcgpkg XercesC uuid AIDA CppUnit xrootd GCCXML libunwind"
	lcgpkg="$lcgpkg tcmalloc pytools Boost HepMC cernlib lapack blas"

	local pkg=""
	for pkg in $lcgpkg
	do
		type -t install-$pkg >& /dev/null
		if [ "$?" = 0 ]; then
			echo call install-$pkg
			install-$pkg
		else
			echo install-$pkg does not exist!
		fi
	done

	install-lcg
	setup-lcg
	lcg-make
}

function install-external-all-bes {
	local lcgpkg="geant4-clhep geant4-geant4 geant4-gdml"
	local pkg=""
	for pkg in $lcgpkg
	do
		type -t install-$pkg >& /dev/null
		if [ "$?" = 0 ]; then
			echo call install-$pkg
			install-$pkg
		else
			echo install-$pkg does not exist!
		fi
	done
}

function install-external-all-gaudi {
	install-gaudi-download
	setup-gaudi

	pushd $EXTERNALLIBDIR/gaudi/GaudiRelease/cmt
	cmt br cmt config
	source setup.sh
	cmt br cmt make
	popd
}

function install-external-all {
	install-external-all-contrib
	install-external-all-lcg

	install-external-all-gaudi
	install-external-all-bes
}
