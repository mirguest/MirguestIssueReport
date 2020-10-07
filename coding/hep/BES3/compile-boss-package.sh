export BOSSDIR=/afs/.ihep.ac.cn/bes3/offline/Boss

function boss-version() {
  echo 6.6.4-slc6
}
function BesRelease-version {
  echo BesRelease-01-02-22
}

function find-BesRelease() {
	local tmppath=$BOSSDIR/$(boss-version)/BesRelease/$(BesRelease-version)
	if [ -d "$tmppath" ];
	then
		echo $tmppath
	fi
}

function compile-package-XXX {
	local msg="=== $FUNCNAME ==="
	local pkgname=$1
	if [ -z "$pkgname" ];
	then
		echo $msg No Package Name!
		return
	fi

	local pkgpath=$(compile-package-XXX-construct-package-path $pkgname)
	compile-package-XXX-build $pkgpath
	
}

# Helper Functions
## construct the path
function compile-package-XXX-construct-package-path() {
  local pkgname=$1
	local cmtpaths=$(find-BesRelease)/cmt/requirements
	if [ ! -f "$cmtpaths" ];
	then
		return
	fi
	local results=$(grep "use $pkgname" $cmtpaths)
	if [ -z "$results" ];
	then
		echo Can\'t Locate Package  $pkgname 1>&2
		return
	fi
	local arrays=($results)
	# first is use
	if [ "use" != "${arrays[0]}" ];
	then
		echo Parse Failed! 1>&2
		return
	fi
	# second is the package name
	if [ "$pkgname" != "${arrays[1]}" ];
	then
		echo Parse Failed! The package name don\'t match 1>&2
		return
	fi
	# third is version number
	local versionnum="${arrays[2]}"
	local offset="${arrays[3]}"
	# construct the path
	local finalpath=$BOSSDIR/$(boss-version)/$offset/$pkgname/$versionnum	
	if [ ! -d $finalpath ];
	then
		echo The directory does not exist: $finalpath 1>&2
		return
	fi
	echo $finalpath
}


## build the package
function compile-package-XXX-build() {
	local msg="==== $FUNCNAME ===="
	local pkgpath=$1
	echo $msg build at $pkgpath 1>&2
	if [ ! -d "$pkgpath/cmt" ];
	then
		return
	fi
	pushd $pkgpath/cmt >& /dev/null
	# build
	type -t "compile-package-user-defined-XXX-build"
	if [ "$?" = "0" ];
	then
		compile-package-user-defined-XXX-build
	else
		cmt br cmt make -j1
	fi
	popd >& /dev/null
}
