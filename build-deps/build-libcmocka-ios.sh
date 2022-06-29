#! /bin/sh

PREFIX=$(pwd)/../deps
TARGET=$(pwd)/../ios

module_map() {
  echo 'module Clibcmocka {'
  echo '    header "cmocka.h"'
  echo '    header "cmocka_pbc.h"'
  echo '    export *'
  echo '}'
}

build() {
    pushd $PREFIX/cmocka

    rm -rf build
    mkdir -p build
    pushd build

    cmake \
    -DCMAKE_SYSTEM_NAME=${1} \
    "-DCMAKE_OSX_ARCHITECTURES=${2}" \
    -DCMAKE_OSX_SYSROOT=${3} \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=9.0 \
    -DCMAKE_INSTALL_PREFIX=$(pwd) \
    -DCMAKE_IOS_INSTALL_COMBINED=YES \
    -DWITH_STATIC_LIB=ON \
    -DWITH_EXAMPLES=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_C_FLAGS=-fembed-bitcode \
    ..

    make && make install

    mv lib/libcmocka-static.a $PREFIX/cmocka/${4}/lib/
    mv include/* $PREFIX/cmocka/${4}/include/
    module_map > "$PREFIX/cmocka/${4}/include/Clibcmocka.modulemap"

    popd
    popd
}

rm -rf $PREFIX/cmocka/ios
rm -rf $PREFIX/cmocka/ios-simulator
rm -rf $TARGET/Clibcmocka.xcframework

pushd $PREFIX/cmocka

mkdir -p ios/include
mkdir -p ios/lib

mkdir -p ios-simulator/include
mkdir -p ios-simulator/lib

popd

XCODEDIR="$(xcode-select -p)"
BASEDIR="${XCODEDIR}/Platforms/iPhoneOS.platform/Developer"
build iOS "armv7;arm64" "${BASEDIR}/SDKs/iPhoneOS.sdk" ios

BASEDIR="${XCODEDIR}/Platforms/iPhoneSimulator.platform/Developer"
build iOS "x86_64;arm64" "${BASEDIR}/SDKs/iPhoneSimulator.sdk" ios-simulator

xcodebuild -create-xcframework \
-library $PREFIX/cmocka/ios/lib/libcmocka-static.a \
-headers $PREFIX/cmocka/ios/include/ \
-library $PREFIX/cmocka/ios-simulator/lib/libcmocka-static.a \
-headers $PREFIX/cmocka/ios-simulator/include/ \
-output $PREFIX/cmocka/Clibcmocka.xcframework

mv $PREFIX/cmocka/Clibcmocka.xcframework $TARGET

rm -rf $PREFIX/cmocka/build
rm -rf $PREFIX/cmocka/ios
rm -rf $PREFIX/cmocka/ios-simulator
