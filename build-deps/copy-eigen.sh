#! /bin/sh

PREFIX=$(pwd)/../deps
TARGET=$(pwd)/../ios

rm -rf $TARGET/Eigen

pushd $TARGET

mkdir -p Eigen
cp -r $PREFIX/eigen/Eigen $TARGET/Eigen

popd
