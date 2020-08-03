@echo off

:menu
if defined ANDROID_HOME (
	echo ANDROID_HOME: %ANDROID_HOME%
) else (
	echo ANDROID_HOME env is not defined
	goto end
)

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.\
cd /d %DIRNAME%

echo ------------------------------
echo   build android on windows
echo ------------------------------
echo 1. arm64-v8a/debug
echo 2. arm64-v8a/release
echo 3. armeabi-v7a/debug
echo 4. armeabi-v7a/release
echo ------------------------------

set /p user_input=Please enter your choice:

if %user_input% geq 5 (
	echo input is invalid
	goto end
)

if %user_input% leq 0 (
	echo input is invalid
	goto end
)

set ARCH=arm64-v8a
set BUILD_TYPE=Debug

if %user_input% equ 2 (
	set ARCH=arm64-v8a
	set BUILD_TYPE=Release
) else (
	if %user_input% equ 3 (
		set ARCH=armeabi-v7a
		set BUILD_TYPE=Debug
	) else (
		if %user_input% equ 4 (
			set ARCH=armeabi-v7a
			set BUILD_TYPE=Release
		)
	)
)

echo ARCH: %ARCH%
echo BUILD_TYPE: %BUILD_TYPE%

echo ==============================================delete cache========================================
del CMakeCache.txt

echo ==============================================configure===========================================
cmake -DANDROID_TOOLCHAIN=clang ^
	-DCMAKE_MAKE_PROGRAM=ninja ^
	-DCMAKE_GENERATOR=Ninja ^
	-DANDROID_CPP_FEATURES="exceptions rtti" ^
	-DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
	-DANDROID_ABI=%ARCH% ^
	-DANDROID_NDK=%ANDROID_HOME%/ndk-bundle ^
	-DCMAKE_TOOLCHAIN_FILE=%ANDROID_HOME%/ndk-bundle/build/cmake/android.toolchain.cmake ^
	-DANDROID_NATIVE_API_LEVEL=23 ^
	-DANDROID_STL=c++_shared ^
	-DLIBRARY_OUTPUT_PATH=../out/Android/%ARCH%/%BUILD_TYPE% ^
	..

echo ================================================build=============================================
rem ninja -C .
cmake --build .

:end
echo ===============================================completed==========================================
pause

goto menu