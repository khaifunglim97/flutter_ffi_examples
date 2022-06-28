#! /bin/sh

PREFIX=$(pwd)/../deps
TARGET=$(pwd)/../ios

rm -rf $TARGET/Clibsodium.xcframework
rm -rf $(pwd)/Clibsodium.xcframework
rm $PREFIX/libsodium/dist-build/libsodium-apple-xcframework-modified.sh

cp $(pwd)/libsodium-apple-xcframework-modified.sh $PREFIX/libsodium/dist-build
chmod 744 $PREFIX/libsodium/dist-build/libsodium-apple-xcframework-modified.sh

pushd $PREFIX/libsodium

./autogen.sh -s
LIBSODIUM_FULL_BUILD=1 ./dist-build/libsodium-apple-xcframework-modified.sh
mv libsodium-apple/Clibsodium.xcframework $TARGET/
rm -rf libsodium-apple
rm dist-build/libsodium-apple-xcframework-modified.sh

popd
