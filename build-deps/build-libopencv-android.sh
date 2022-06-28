#!/bin/sh

if [ -z "$ANDROID_HOME" ]; then
    echo "Please set ANDROID_HOME with the directory containing Android SDK"
    exit 1
fi

if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "Please set ANDROID_NDK_HOME with the directory containing Android NDK"
    exit 1
fi

PREFIX=$(pwd)/../deps
TARGET=$(pwd)/../android/deps

rm -rf $(pwd)/OpenCV-android-sdk
rm -rf $(pwd)/o4a
rm -rf $TARGET/opencv2

mkdir -p $TARGET/opencv2

python3 $PREFIX/opencv/platforms/android/build_sdk.py \
--sdk_path $ANDROID_HOME \
--ndk_path $ANDROID_NDK_HOME \
--extra_modules_path $PREFIX/opencv_contrib/modules/

mv $(pwd)/OpenCV-android-sdk/sdk/native/staticlibs/*/ $TARGET/opencv2/
mv $(pwd)/OpenCV-android-sdk/sdk/native/jni/include $TARGET/opencv2/
mv $(pwd)/OpenCV-android-sdk/sdk/native/3rdparty/libs/ $TARGET/opencv2/3rdparty/

rm -rf $(pwd)/o4a
rm -rf $(pwd)/OpenCV-android-sdk
