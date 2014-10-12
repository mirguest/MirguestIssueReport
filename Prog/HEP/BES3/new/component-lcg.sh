#!/bin/bash

# This is for lcg specific libraries
# Used by install-all.sh

# == contrib ==
# === gcc ===
function install-gcc-package-name() {
    echo gcc_4.6.3__LCG_${CMTCONFIG}.tar.gz
}
function install-gcc-download-url() {
    echo $INSTALL_SPI_URL/gcc_4.6.3__LCG_${CMTCONFIG}.tar.gz
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
    popd 
}
function setup-gcc() {
    export PATH=$DEVROOT/contrib/gcc/4.6.3/x86_64-slc6/bin:$PATH
    export LD_LIBRARY_PATH=$DEVROOT/contrib/gcc/4.6.3/x86_64-slc6/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$DEVROOT/contrib/gcc/4.6.3/x86_64-slc6/lib64:$LD_LIBRARY_PATH
}

# === cmt ===

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
    popd
}
function setup-cmt() {
    setup-gcc
    pushd $(cmt-mgr-path)
    source setup.sh
    popd
}

# == LCGCMT ==
function lcg-version {
    echo LCGCMT_65a
}
function install-lcg-package-name() {
    echo LCGCMT_65a.tar.gz
}
function install-lcg-download-url() {
    echo $INSTALL_SPI_URL/LCGCMT_65a.tar.gz
}

function install-lcg-patch-lcg-settings {
cat << EOF > bespatch/lcg-settings.patch
--- LCGCMT_65a/LCG_Settings/cmt/requirements    2014-03-07 20:24:47.000000001 +0800
+++ LCGCMT_65a/LCG_Settings/cmt/requirements    2014-03-07 20:29:25.000000001 +0800
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
cat << EOF > bespatch/lcg-clhep.patch
--- LCGCMT_65a/LCG_Configuration/cmt/requirements       2014-03-07 20:24:56.000000001 +0800
+++ LCGCMT_65a/LCG_Configuration/cmt/requirements       2014-03-28 12:17:53.000000001 +0800
@@ -31,7 +31,8 @@
       target-mac                         "2.1.9-4"
 macro cernlib_config_version             "2006a"
 macro cgsigsoap_config_version           "1.3.3-1"
-macro CLHEP_config_version               "1.9.4.7"
+#macro CLHEP_config_version               "1.9.4.7"
+macro CLHEP_config_version               "2.0.4.5"
 macro cmake_config_version               "2.8.9"
 macro cmt_config_version                 "v1r20p20081118"
 macro coin3d_config_version              "3.1.3p2"

EOF
patch -p0  < $EXTERNALLIBDIR/LCGCMT/bespatch/lcg-clhep.patch
}
function install-lcg-patch {
    pushd $EXTERNALLIBDIR/LCGCMT >& /dev/null
    # AT THE TOP TREE
    if [ ! -d "bespatch" ];
    then
        mkdir bespatch
    fi
    echo ===== PATCH LCGCMT
    install-lcg-patch-lcg-settings

    popd >& /dev/null
}

function install-lcg-real() {
    echo $FUNCNAME  
    if [ ! -f "$DOWNLOADDIR/$(install-lcg-package-name)" ];
    then
        pushd $DOWNLOADDIR >& /dev/null
        wget $(install-lcg-download-url)
        popd >& /dev/null
    fi
    pushd $DOWNLOADDIR >& /dev/null
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
    popd >& /dev/null
}
function install-lcg {
    setup-cmt
    if [ ! -d $EXTERNALLIBDIR ];
    then
        mkdir $EXTERNALLIBDIR
    fi
    pushd $EXTERNALLIBDIR >& /dev/null
    if [ ! -d LCGCMT ];
    then
        install-lcg-real
    fi
    popd >& /dev/null
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

# == Gaudi ==
#get Gaudi
function install-gaudi-version {
    echo GAUDI_v23r9
}
function install-gaudi-download {
    pushd $EXTERNALLIBDIR >& /dev/null
    if [ ! -d "gaudi" ]; 
    then
        mkdir gaudi
    fi

    pushd gaudi >& /dev/null
    local gaudiversion=$(install-gaudi-version)
    if [ ! -d "$gaudiversion" ];
    then
        git clone http://git.cern.ch/pub/gaudi $gaudiversion
        pushd $gaudiversion >& /dev/null
        git checkout -b $gaudiversion remotes/origin/svn/tags/$gaudiversion
        popd >& /dev/null
    fi
    popd >& /dev/null
    popd  >& /dev/null
}

function setup-gaudi {
  setup-lcg
  export CMTPATH=$EXTERNALLIBDIR/gaudi/$(install-gaudi-version):${CMTPATH}
}

# == Helper for LCG ==
# helper
function install-PKG-helper-generate-download-url {
    local pkgname=$1
    echo ${INSTALL_SPI_URL}/$(install-$pkgname-package-name)
}
function install-PKG {
    local pkgname=$1
    echo $FUNCNAME  
    if [ ! -f "$DOWNLOADDIR/$(install-$pkgname-package-name)" ];
    then
        pushd $DOWNLOADDIR

        type -t install-$pkgname-download-url >& /dev/null
        if [ "$?" = "0" ];
        then
            wget $(install-$pkgname-download-url)
        else
            wget $(install-PKG-helper-generate-download-url $pkgname)
        fi
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

# == LCG Externals ==
# === Python ===

function install-python-package-name() {
    echo Python_2.7.3__LCG_${CMTCONFIG}.tar.gz
}

function install-python-download-url() {
    install-PKG-helper-generate-download-url python
}

function install-python {
    install-PKG python
}

# === HepPDT ===
function install-HepPDT-package-name() {
    echo HepPDT_2.06.01__LCG_${CMTCONFIG}.tar.gz
}

function install-HepPDT {
    install-PKG HepPDT
}
# === RELAX ===
function install-RELAX-package-name() {
    echo RELAX_1_3_0m__LCG_${CMTCONFIG}.tar.gz
}

function install-RELAX {
    install-PKG RELAX
}

# === ROOT ===
function install-ROOT-env {
    export ROOTSYS=$EXTERNALLIBDIR/external/ROOT/5.34.09/${CMTCONFIG}/root
    export PATH=$ROOTSYS/bin:$PATH
    export LD_LIBRARY_PATH=$ROOTSYS/lib/:$LD_LIBRARY_PATH
}

function install-ROOT-package-name {
    echo ROOT_5.34.09__LCG_${CMTCONFIG}.tar.gz
}

function install-ROOT {
    install-PKG ROOT
}

# === GSL ===
function install-GSL-package-name {
    echo GSL_1.10__LCG_${CMTCONFIG}.tar.gz
}
function install-GSL {
    install-PKG GSL
}

# === CASTOR ===
function install-castor-package-name {
    echo CASTOR_2.1.13-6__LCG_${CMTCONFIG}.tar.gz
}
function install-CASTOR {
    install-PKG castor
}

# === mysql ===
function install-mysql-package-name {
    echo mysql_5.5.14__LCG_${CMTCONFIG}.tar.gz
}

function install-mysql {
    install-PKG mysql
}
# === sqlite ===
function install-sqlite-package-name {
    echo sqlite_3070900__LCG_${CMTCONFIG}.tar.gz 
}

function install-sqlite {
    install-PKG sqlite
}

# === clhep === 
function install-clhep-package-name {
    echo CLHEP_1.9.4.7__LCG_${CMTCONFIG}.tar.gz
}

function install-CLHEP {
    install-PKG clhep
}

# === XercesC ===

function install-XercesC-package-version {
    echo 3.1.1p1
}

function install-XercesC-package-name {
    echo XercesC_3.1.1p1__LCG_${CMTCONFIG}.tar.gz
}

function install-XercesC {
    install-PKG XercesC
}

# === uuid ===
function install-uuid-package-name {
    echo uuid_1.42__LCG_${CMTCONFIG}.tar.gz
}
function install-uuid-from-yum {
    yum install libuuid-devel
}

function install-uuid {
    install-PKG uuid
    # using yum to install libuuid
    install-uuid-from-yum
}

# === AIDA === 
function install-AIDA-package-name {
    echo AIDA_3.2.1__LCG_${CMTCONFIG}.tar.gz
}

function install-AIDA {
    install-PKG AIDA
}

# === CppUnit ===
function install-CppUnit-package-name {
    echo CppUnit_1.12.1_p1__LCG_${CMTCONFIG}.tar.gz
}

function install-CppUnit {
    install-PKG CppUnit
}

# === xrootd ===
function install-xrootd-package-name {
    echo xrootd_3.2.7__LCG_${CMTCONFIG}.tar.gz
}
function install-xrootd {
    install-PKG xrootd
}

# === gccxml ===
function install-gccxml-package-name {
    echo GCCXML_0.9.0_20120309p2__LCG_${CMTCONFIG}.tar.gz
}

function install-GCCXML {
    install-PKG gccxml
}

# === libunwind ===
function install-libunwind-package-name {
    echo libunwind_5c2cade__LCG_${CMTCONFIG}.tar.gz
}
function install-libunwind {
    install-PKG libunwind
}

# === tcmalloc ===
function install-tcmalloc-package-name {
    echo tcmalloc_1.7p3__LCG_${CMTCONFIG}.tar.gz
}

function install-tcmalloc {
    install-PKG tcmalloc
}

# === pytools ===
function install-pytools-package-name {
    echo pytools_1.8_python2.7__LCG_${CMTCONFIG}.tar.gz
}

function install-pytools {
    install-PKG pytools
}

# === Boost ===

function install-Boost-package-name {
    echo Boost_1.50.0_python2.7__LCG_${CMTCONFIG}.tar.gz
}

function install-Boost {
    install-PKG Boost
}

# === HepMC ===

function install-HepMC-package-name {
    echo HepMC_2.06.08__LCG_${CMTCONFIG}.tar.gz
}

function install-HepMC {
    install-PKG HepMC
}

# === cernlib ===
function install-cernlib-package-name {
    echo cernlib_2006a__LCG_${CMTCONFIG}.tar.gz
}

function install-cernlib {
    install-PKG cernlib
}

# === lapack ===

function install-lapack-package-name {
    echo lapack_3.4.0__LCG_${CMTCONFIG}.tar.gz
}
function install-lapack {
    install-PKG lapack
}

# === blas ===
function install-blas-package-name {
    echo blas_20110419__LCG_${CMTCONFIG}.tar.gz
}

function install-blas {
    install-PKG blas
}

# === valgrind ===
function install-valgrind-package-name {
    echo valgrind_3.8.0__LCG_${CMTCONFIG}.tar.gz
}

function install-valgrind {
   install-PKG valgrind
}
