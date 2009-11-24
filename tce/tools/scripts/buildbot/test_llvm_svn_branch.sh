#!/bin/bash
# Copyright (c) 2002-2009 Tampere University of Technology.
#
# This file is part of TTA-Based Codesign Environment (TCE).
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

TEST_DIRECTORY="/tmp/llvm_svn_test"

# find bzr root directory for ran script
TCE_LLVM_BZR_ROOT=`echo -e "import os\nprint os.path.abspath('$0').split('/tce/tools/scripts')[0]\n" | python`
echo "Found tce branch root directory from: $TCE_LLVM_BZR_ROOT"

echo "---------- Finding last stable llvm rev -----------"
GOOD_LLVM_REV=`$TCE_LLVM_BZR_ROOT/tce/tools/scripts/find_good_llvm_svn_revision.py`
echo "Found $GOOD_LLVM_REV"

INSTALL_DIRECTORY=$TEST_DIRECTORY/llvm-install
echo "Installing llvm and llvm-gcc to $INSTALL_DIRECTORY"

export PATH=$INSTALL_DIRECTORY/bin:$PATH

# remove old installation and update tce branch
rm -fr $INSTALL_DIRECTORY
mkdir -p $INSTALL_DIRECTORY
cd $TCE_LLVM_BZR_ROOT

echo "---------- Updating tce bzr branch in $PWD -----------"
bzr up

# used in update svn installation script
export SVN_REV="-r $GOOD_LLVM_REV"

# checkout or update llvm-svn installation
export SVN_REPO_DIR="$TEST_DIRECTORY/llvm-trunk"
export BUILD_DIR="$TEST_DIRECTORY/llvm-build"
export SVN_REPO_URL="http://llvm.org/svn/llvm-project/llvm/trunk"
export CONFIGURE_COMMAND="$SVN_REPO_DIR/configure --enable-optimized --prefix=$INSTALL_DIRECTORY"

$TCE_LLVM_BZR_ROOT/tce/tools/scripts/buildbot/update_svn_installation.sh

# checkout or update llvm-gcc installation
export SVN_REPO_DIR="$TEST_DIRECTORY/llvm-gcc-trunk"
export BUILD_DIR="$TEST_DIRECTORY/llvm-gcc-build"
export SVN_REPO_URL="http://llvm.org/svn/llvm-project/llvm-gcc-4.2/trunk"
export CONFIGURE_COMMAND="$TCE_LLVM_BZR_ROOT/tce-llvm-gcc/configure --prefix=$INSTALL_DIRECTORY --with-llvm-gcc-sources=$TEST_DIRECTORY/llvm-gcc-trunk"

# run autoreconf if there's no configure
if [ ! -e $TCE_LLVM_BZR_ROOT/tce-llvm-gcc/configure ]
then
	autoreconf $TCE_LLVM_BZR_ROOT/tce-llvm-gcc/
fi

$TCE_LLVM_BZR_ROOT/tce/tools/scripts/buildbot/update_svn_installation.sh

# update and test tce copied from nightly test...
BRANCH_DIR=$TCE_LLVM_BZR_ROOT
cd "${BRANCH_DIR}/tce"
${BRANCH_DIR}/tce/src/bintools/Compiler/tcecc --clear-plugin-cache

#export CXX="ccache g++${ALTGCC}"
#export CC="ccache gcc${ALTGCC}"
#export CXXFLAGS="-O3 -Wall -pedantic -Wno-long-long -g -Wno-variadic-macros -Wno-deprecated"
#export CPPFLAGS="-O3 -Wall -pedantic -Wno-long-long -g -Wno-variadic-macros -Wno-deprecated"

./gen_config.sh
if [ -x gen_llvm_shared_lib.sh ] 
then
    ./gen_llvm_shared_lib.sh
fi

tools/scripts/compiletest.sh 

if [ -s compiletest.error.log ]
then
   exit 1
fi
exit 0
