#! /bin/sh

if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "Please set ANDROID_NDK_HOME with the directory containing Android NDK"
    exit 1
fi

PREFIX=$(pwd)/../deps
TARGET=$(pwd)/../android/deps

build() {

    rm -rf $PREFIX/cmocka/build
    mkdir -p $PREFIX/cmocka/build

    mkdir -p $TARGET/libcmocka/${1}

    pushd $PREFIX/cmocka/build
    cmake -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_ANDROID_ARCH_ABI=${1} \
    -DCMAKE_ANDROID_NDK=${ANDROID_NDK_HOME} \
    -DCMAKE_ANDROID_STL_TYPE=c++_static \
    -DWITH_STATIC_LIB=TRUE \
    -DCMAKE_INSTALL_PREFIX=$(pwd) \
    ..

    make && make install
    mv lib/libcmocka-static.a $TARGET/libcmocka/${1}/
    mv include/*.h $TARGET/libcmocka/include/
    popd
}

rm -rf $PREFIX/cmocka/build
rm -rf $TARGET/libcmocka

mkdir -p $TARGET/libcmocka/include

for arch in arm64-v8a armeabi-v7a x86 x86_64; do
    build $arch
done

rm -rf $PREFIX/cmocka/build
