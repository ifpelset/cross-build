#!/bin/bash

PRG=$0
cd `dirname $PRG`

echo "------------------------------"
echo "  build iOS on macOS          "
echo "------------------------------"
echo "1. arm64/debug                "
echo "2. arm64/release              "
echo "------------------------------"

read -p "Please enter your choice:" user_input

if [ $user_input -ge 5 ] || [ $user_input -le 0 ]; then
	echo "input is invalid"
	exit -1
fi

ARCH=arm64
BUILD_TYPE=Debug

if [ $user_input -eq 2 ]; then
	ARCH=arm64-v8a
	BUILD_TYPE=Release
fi

echo "ARCH: $ARCH"
echo "BUILD_TYPE: $BUILD_TYPE"

echo "==============================================delete cache========================================"
rm -rf CMakeCache.txt

echo "==============================================configure==========================================="
cmake -Wno-dev \
	-DCMAKE_MAKE_PROGRAM=ninja \
	-DCMAKE_GENERATOR=Ninja \
	-DCMAKE_BUILD_TYPE=$BUILD_TYPE \
	-DIOS_ARCH=$ARCH \
	-DCMAKE_TOOLCHAIN_FILE=toolchain/iOS.cmake \
	-DLIBRARY_OUTPUT_PATH=../out/iOS/$ARCH/$BUILD_TYPE \
	..

echo "================================================build============================================="
#ninja -C .
cmake --build .

echo "===============================================completed=========================================="
