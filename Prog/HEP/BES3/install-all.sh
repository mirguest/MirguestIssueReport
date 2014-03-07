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

##git clone http://git.cern.ch/pub/gaudi
#cd gaudi
#git checkout -b GAUDI_v23r9 remotes/origin/svn/tags/GAUDI_v23r9

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
