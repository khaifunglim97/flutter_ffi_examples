#! /bin/sh

if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "Please set ANDROID_NDK_HOME with the directory containing Android NDK"
    exit 1
fi

export LIBSODIUM_FULL_BUILD=1
export NDK_PLATFORM="android-21"

TOOLCHAIN_OS_DIR="$(uname | tr '[:upper:]' '[:lower:]')-x86_64"
TOOLCHAIN_BIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/${TOOLCHAIN_OS_DIR}/bin"
export AR="${TOOLCHAIN_BIN}/llvm-ar"
export RANLIB="${TOOLCHAIN_BIN}/llvm-ranlib"
export STRIP="${TOOLCHAIN_BIN}/llvm-strip"

BUILD_PREFIX=$(pwd)/../deps
BUILD_TARGET=$(pwd)/../android/deps

rm -rf $BUILD_TARGET/libsodium
mkdir -p $BUILD_TARGET/libsodium
mkdir -p $BUILD_TARGET/libsodium/include

pushd $BUILD_PREFIX/libsodium

./autogen.sh -s

build() {
  rm -rf "libsodium-android-${2}"

  "./dist-build/android-${1}.sh"

  mkdir -p "$BUILD_TARGET/libsodium/${3}"
  mv "libsodium-android-${2}/include/" $BUILD_TARGET/libsodium/
  mv "libsodium-android-${2}/lib/libsodium.a" "$BUILD_TARGET/libsodium/${3}"
  rm -rf "libsodium-android-${2}"
}

build x86 i686 x86 || exit 1
build x86_64 westmere x86_64 || exit 1
build armv7-a armv7-a armeabi-v7a || exit 1
build armv8-a "armv8-a+crypto" arm64-v8a || exit 1

popd
