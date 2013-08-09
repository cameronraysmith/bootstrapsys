#!/bin/bash

#-------------------------------------------------------
# Script to install the Haskell platform from source
# requires two inputs
# the Haskell Platform version (e.g. "2012.4.0.0")
# the GHC version (e.g. "7.4.2")
# check Platform/GHC version matching here:
# http://www.vex.net/~trebla/haskell/haskell-platform.xhtml
#-------------------------------------------------------

#HPVERSION=2011.4.0.0
#GHCVERSION=7.0.4
HPVERSION=$1
GHCVERSION=$2
HPATH=/usr/local/haskell-$HPVERSION

if [ ! $# == 2 ]; then
   echo "Usage: sudo $0 Haskell_platform_version GHC_version"
   echo "Example: sudo $0 2011.4.0.0 7.0.4"
   exit 1
fi

if [ -d ~/Downloads ]; then
   cd ~/Downloads
else
   echo "make sure there is a Downloads directory in your root directory"
   exit 1
fi

#curl -O http://lambda.haskell.org/platform/download/2011.4.0.0/haskell-platform-2011.4.0.0.tar.gz
curl -O http://lambda.haskell.org/platform/download/$HPVERSION/haskell-platform-$HPVERSION.tar.gz &
#curl -O http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-unknown-linux.tar.bz2
curl -O http://www.haskell.org/ghc/dist/$GHCVERSION/ghc-$GHCVERSION-x86_64-unknown-linux.tar.bz2 &
wait
tar xjf ghc-$GHCVERSION-x86_64-unknown-linux.tar.bz2
wait
tar xzf haskell-platform-$HPVERSION.tar.gz
wait
mkdir -p $HPATH

# configure/make/install GHC
cd ghc-$GHCVERSION
./configure --prefix=$HPATH
make install

# add new directory containing GHC to front of PATH variable
PATH=$HPATH/bin:$PATH
export PATH

# configure/make/install the Haskell platform
cd ~/Downloads/haskell-platform-$HPVERSION
./configure --prefix=$HPATH
make
make install

# cleanup
cd ~/Downloads
if [ -d "ghc-$GHCVERSION" ]; then
       rm -r ghc-$GHCVERSION
fi

if [ -d "haskell-platform-$HPVERSION" ]; then
       rm -r haskell-platform-$HPVERSION
fi

if [ -f "ghc-$GHCVERSION-x86_64-unknown-linux.tar.bz2" ]; then
       rm -r ghc-$GHCVERSION-x86_64-unknown-linux.tar.bz2
fi

if [ -f "haskell-platform-$HPVERSION.tar.gz" ]; then
       rm -r haskell-platform-$HPVERSION.tar.gz
fi

echo ""
echo "--------------------------------------"
echo ""
echo "installed Haskell platform $HPVERSION with GHC $GHCVERSION"
echo "remember to change PATH,.cabal/config install-dirs global prefix, and aliases to:"
echo "$HPATH/bin"
echo "then run sudo cabal install --global --prefix=$HPATH/bin world"
echo "which will reinstall all packages listed in the .cabal/world file"
echo ""
exit 0
