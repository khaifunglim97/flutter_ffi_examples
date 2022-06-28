#! /bin/sh

PREFIX=$(pwd)/../deps
TARGET=$(pwd)/../ios

rm -rf $TARGET/opencv2.xcframework
rm -rf $(pwd)/opencv2.xcframework

python3 $PREFIX/opencv/platforms/apple/build_xcframework.py \
--contrib $PREFIX/opencv_contrib \
--iphoneos_archs arm64,armv7 \
--iphonesimulator_archs arm64,x86_64 \
--build_only_specified_archs \
-o opencv2.xcframework

mv $(pwd)/opencv2.xcframework/opencv2.xcframework $TARGET/
rm -rf $(pwd)/opencv2.xcframework
