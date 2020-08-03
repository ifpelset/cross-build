#!/bin/bash

if [ -z $ANDROID_HOME ]; then
	echo "ANDROID_HOME is not defined"
	exit -1
fi

PRG=$0
cd `dirname $PRG`

echo "ANDROID_HOME: $ANDROID_HOME"

echo "------------------------------"
echo "  build android on *nix       "
echo "------------------------------"
echo "1. arm64-v8a/debug            "
echo "2. arm64-v8a/release          "
echo "3. armeabi-v7a/debug          "
echo "4. armeabi-v7a/release        "
echo "------------------------------"

read -p "Please enter your choice:" user_input

if [ $user_input -ge 5 ] || [ $user_input -le 0 ]; then
	echo "input is invalid"
	exit -1
fi

ARCH=arm64-v8a
BUILD_TYPE=Debug

if [ $user_input -eq 2 ]; then
	ARCH=arm64-v8a
	BUILD_TYPE=Release
elif [ $user_input -eq 3 ]; then
	ARCH=armeabi-v7a
	BUILD_TYPE=Debug
elif [ $user_input -eq 4 ]; then
	ARCH=armeabi-v7a
	BUILD_TYPE=Release
fi

echo "ARCH: $ARCH"
echo "BUILD_TYPE: $BUILD_TYPE"

echo "==============================================delete cache========================================"
rm -rf CMakeCache.txt

echo "==============================================configure==========================================="
cmake -DANDROID_TOOLCHAIN=clang \
	-DCMAKE_MAKE_PROGRAM=ninja \
	-DCMAKE_GENERATOR=Ninja \
	-DANDROID_CPP_FEATURES="exceptions rtti" \
	-DCMAKE_BUILD_TYPE=$BUILD_TYPE \
	-DANDROID_ABI=$ARCH \
	-DANDROID_NDK=$ANDROID_HOME/ndk-bundle \
	-DCMAKE_TOOLCHAIN_FILE=$ANDROID_HOME/ndk-bundle/build/cmake/android.toolchain.cmake \
	-DANDROID_NATIVE_API_LEVEL=23 \
	-DANDROID_STL=c++_shared \
	-DLIBRARY_OUTPUT_PATH=../out/Android/$ARCH/$BUILD_TYPE \
	..

echo "================================================build============================================="
# ninja -C .
cmake --build .

echo "===============================================completed=========================================="
