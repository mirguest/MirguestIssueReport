export DEVROOT=/home/ihep/dev/boss-dev/ExternalLib/SLC6
export DOWNLOADDIR=$DEVROOT/download
export EXTERNALLIBDIR=$DEVROOT/ExternalLib
export CONTRIBDIR=$DEVROOT/contrib
export CMTCONFIG=x86_64-slc6-gcc46-opt
export BOSSDIR=/home/ihep/dev/boss-dev/Boss
export INSTALL_SPI_URL=http://service-spi.web.cern.ch/service-spi/external/distribution

if [ ! -d $DOWNLOADDIR ];
then
  mkdir -p $DOWNLOADDIR
fi


# LCG
  
source component-lcg.sh
source component-boss.sh



#install boss
function boss-version() {
    echo 6.6.4.b
}
function BesRelease-version {
    echo BesRelease-01-02-27
}

function setup-cvs {
    export CVSROOT=':pserver:lint@koala.ihep.ac.cn:/bes/bes'
    export CVSIGNORE='setup.* cleanup.* x86_64-slc5-gcc46* *.make Makefile Linux* *~ rh73_gcc32 i386* '
}
function setup-cmt-cvs {
    setup-cmt

    pushd $(cmt-mgr-path)
    sed -i 's/^\(macro cmt_cvs_protocol_level "v1r1"\)/#\1/' requirements
    cmt config
    source setup.sh
    popd
}
function generate-project-for-boss {
    if [ ! -d "cmt" ]; then
      mkdir cmt
    fi
    if [ ! -f "cmt/project.cmt" ]; then
cat << EOF > cmt/project.cmt
project BOSS
 use LCGCMT LCGCMT_65a
 use GAUDI GAUDI_v23r9
 build_strategy with_installarea
 structure_strategy with_version_directory
 setup_strategy root
 container BesRelease
EOF
    fi
}
function checkout-boss {
    setup-cvs
    setup-boss
    setup-cmt-cvs
    if [ ! -d $BOSSDIR/$(boss-version) ];
    then
        mkdir $BOSSDIR/$(boss-version)
    fi
    pushd $BOSSDIR/$(boss-version)
    # generate project file
    generate-project-for-boss
    cmt co -r $(BesRelease-version) BesRelease
    cmt co -requirements BesRelease/*/cmt/requirements
    popd
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
    local lcgpkg="python HepPDT RELAX ROOT GSL CASTOR mysql sqlite CLHEP"
    lcgpkg="$lcgpkg XercesC uuid AIDA CppUnit xrootd GCCXML libunwind"
    lcgpkg="$lcgpkg tcmalloc pytools Boost HepMC cernlib lapack blas"
    lcgpkg="$lcgpkg valgrind"

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

function scp-external-from-afs-to-here () {
    local pkg=$1

    type -t install-$pkg-source-copy-from >& /dev/null

    if [ "$?" = 0 ] ; then
        local remotepath=$(install-$pkg-source-copy-from "yes")
        local fullpath=$(install-$pkg-source-copy-from)
        if [ ! -d "$(dirname $fullpath)" ]; then
            mkdir -p $(dirname $fullpath)
        fi
        if [ ! -d "$fullpath" ]; then
            scp -r "lint@bws0627:$remotepath" $fullpath
        fi
    else
        echo install-$pkg-source-copy-from does not exist
    fi
}

function copy-external-all-bes {
    local lcgpkg="geant4-geant4 geant4-gdml"
    lcgpkg="$lcgpkg genbes BESCLHEP-Alist BESCLHEP-String"
    local pkg=""
    for pkg in $lcgpkg
    do
        scp-external-from-afs-to-here $pkg
    done
}

function install-external-all-bes {
    local lcgpkg="geant4-clhep geant4-geant4 geant4-gdml"
    lcgpkg="$lcgpkg dim xmlrpc"
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

function install-external-all-lcgcmt {
    install-lcg
    setup-lcg
    lcg-make
}

function install-external-all-gaudi {
    install-gaudi-download
    setup-gaudi

    pushd $EXTERNALLIBDIR/gaudi/$(install-gaudi-version)/GaudiRelease/cmt
    cmt br cmt config
    source setup.sh
    cmt br cmt make
    popd
}

function install-external-all {
    install-external-all-contrib
    install-external-all-lcg
    copy-external-all-bes 
    install-external-all-bes
    install-external-all-lcgcmt

    install-external-all-gaudi
    # checkout boss
    # install genbes BESCLHEP-Alist BESCLHEP-String
    # build boss
}
