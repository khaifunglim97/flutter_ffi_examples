#! /bin/sh

export PREFIX="$(pwd)/libsodium-apple"
export IOS32_PREFIX="${PREFIX}/tmp/ios32"
export IOS32s_PREFIX="${PREFIX}/tmp/ios32s"
export IOS64_PREFIX="${PREFIX}/tmp/ios64"
export IOS_SIMULATOR_ARM64_PREFIX="${PREFIX}/tmp/ios-simulator-arm64"
export IOS_SIMULATOR_I386_PREFIX="${PREFIX}/tmp/ios-simulator-i386"
export IOS_SIMULATOR_X86_64_PREFIX="${PREFIX}/tmp/ios-simulator-x86_64"
export LOG_FILE="${PREFIX}/tmp/build_log"
export XCODEDIR="$(xcode-select -p)"

export IOS_SIMULATOR_VERSION_MIN=${IOS_SIMULATOR_VERSION_MIN-"9.0.0"}
export IOS_VERSION_MIN=${IOS_VERSION_MIN-"9.0.0"}

echo
echo "Warnings related to headers being present but not usable are due to functions"
echo "that didn't exist in the specified minimum iOS version level."
echo "They can be safely ignored."
echo

if [ -z "$LIBSODIUM_FULL_BUILD" ]; then
  export LIBSODIUM_ENABLE_MINIMAL_FLAG="--enable-minimal"
else
  export LIBSODIUM_ENABLE_MINIMAL_FLAG=""
fi

APPLE_SILICON_SUPPORTED=false
echo 'int main(void){return 0;}' >comptest.c && cc --target=arm64-macos comptest.c 2>/dev/null && APPLE_SILICON_SUPPORTED=true
rm -f comptest.c

NPROCESSORS=$(getconf NPROCESSORS_ONLN 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null)
PROCESSORS=${NPROCESSORS:-3}

swift_module_map() {
  echo 'module Clibsodium {'
  echo '    header "sodium.h"'
  echo '    export *'
  echo '}'
}

build_ios() {
  export BASEDIR="${XCODEDIR}/Platforms/iPhoneOS.platform/Developer"
  export PATH="${BASEDIR}/usr/bin:$BASEDIR/usr/sbin:$PATH"
  export SDK="${BASEDIR}/SDKs/iPhoneOS.sdk"

  ## 32-bit iOS
  export CFLAGS="-fembed-bitcode -O2 -mthumb -arch armv7 -isysroot ${SDK} -mios-version-min=${IOS_VERSION_MIN}"
  export LDFLAGS="-fembed-bitcode -mthumb -arch armv7 -isysroot ${SDK} -mios-version-min=${IOS_VERSION_MIN}"

  make distclean >/dev/null 2>&1
  ./configure --host=arm-apple-darwin10 --prefix="$IOS32_PREFIX" \
    ${LIBSODIUM_ENABLE_MINIMAL_FLAG} || exit 1
  make -j${PROCESSORS} install || exit 1

  ## 64-bit iOS
  export CFLAGS="-fembed-bitcode -O2 -arch arm64 -isysroot ${SDK} -mios-version-min=${IOS_VERSION_MIN}"
  export LDFLAGS="-fembed-bitcode -arch arm64 -isysroot ${SDK} -mios-version-min=${IOS_VERSION_MIN}"

  make distclean >/dev/null 2>&1
  ./configure --host=arm-apple-darwin10 --prefix="$IOS64_PREFIX" \
    ${LIBSODIUM_ENABLE_MINIMAL_FLAG} || exit 1
  make -j${PROCESSORS} install || exit 1
}

build_ios_simulator() {
  export BASEDIR="${XCODEDIR}/Platforms/iPhoneSimulator.platform/Developer"
  export PATH="${BASEDIR}/usr/bin:$BASEDIR/usr/sbin:$PATH"
  export SDK="${BASEDIR}/SDKs/iPhoneSimulator.sdk"

  ## arm64 simulator
  if [ "$APPLE_SILICON_SUPPORTED" = "true" ]; then
    export CFLAGS="-fembed-bitcode -O2 -arch arm64 -isysroot ${SDK} -mios-simulator-version-min=${IOS_SIMULATOR_VERSION_MIN}"
    export LDFLAGS="-fembed-bitcode -arch arm64 -isysroot ${SDK} -mios-simulator-version-min=${IOS_SIMULATOR_VERSION_MIN}"

    make distclean >/dev/null 2>&1
    ./configure --host=arm-apple-darwin20 --prefix="$IOS_SIMULATOR_ARM64_PREFIX" \
      ${LIBSODIUM_ENABLE_MINIMAL_FLAG} || exit 1
    make -j${PROCESSORS} install || exit 1
  fi

  ## x86_64 simulator
  export CFLAGS="-fembed-bitcode -O2 -arch x86_64 -isysroot ${SDK} -mios-simulator-version-min=${IOS_SIMULATOR_VERSION_MIN}"
  export LDFLAGS="-fembed-bitcode -arch x86_64 -isysroot ${SDK} -mios-simulator-version-min=${IOS_SIMULATOR_VERSION_MIN}"

  make distclean >/dev/null 2>&1
  ./configure --host=x86_64-apple-darwin10 --prefix="$IOS_SIMULATOR_X86_64_PREFIX" \
    ${LIBSODIUM_ENABLE_MINIMAL_FLAG}
  make -j${PROCESSORS} install || exit 1
}

mkdir -p "${PREFIX}/tmp"
echo "Building for iOS..."
build_ios >"$LOG_FILE" 2>&1 || exit 1
echo "Building for the iOS simulator..."
build_ios_simulator >"$LOG_FILE" 2>&1 || exit 1

echo "Adding the Clibsodium module map for Swift..."

## to avoid module map name collisions
find "$PREFIX" -name "include" -type d -print | while read -r f; do
  swift_module_map >"${f}/Clibsodium.modulemap"
done

echo "Bundling iOS targets..."

mkdir -p "${PREFIX}/ios/lib"
cp -a "${IOS64_PREFIX}/include" "${PREFIX}/ios/"
for ext in a dylib; do
  lipo -create \
    "$IOS32_PREFIX/lib/libsodium.${ext}" \
    "$IOS64_PREFIX/lib/libsodium.${ext}" \
    -output "$PREFIX/ios/lib/libsodium.${ext}"
done

echo "Bundling iOS simulators..."

mkdir -p "${PREFIX}/ios-simulators/lib"
cp -a "${IOS_SIMULATOR_X86_64_PREFIX}/include" "${PREFIX}/ios-simulators/"
for ext in a dylib; do
  if [ "$APPLE_SILICON_SUPPORTED" = "true" ]; then
    lipo -create \
      "${IOS_SIMULATOR_ARM64_PREFIX}/lib/libsodium.${ext}" \
      "${IOS_SIMULATOR_X86_64_PREFIX}/lib/libsodium.${ext}" \
      -output "${PREFIX}/ios-simulators/lib/libsodium.${ext}" || exit 1
  else
    lipo -create \
      "${IOS_SIMULATOR_X86_64_PREFIX}/lib/libsodium.${ext}" \
      -output "${PREFIX}/ios-simulators/lib/libsodium.${ext}" || exit 1
  fi
done

echo "Creating Clibsodium.xcframework..."

rm -rf "${PREFIX}/Clibsodium.xcframework"

XCFRAMEWORK_ARGS=""
for f in ios ios-simulators; do
  XCFRAMEWORK_ARGS="${XCFRAMEWORK_ARGS} -library ${PREFIX}/${f}/lib/libsodium.a"
  XCFRAMEWORK_ARGS="${XCFRAMEWORK_ARGS} -headers ${PREFIX}/${f}/include"
done
xcodebuild -create-xcframework \
  ${XCFRAMEWORK_ARGS} \
  -output "${PREFIX}/Clibsodium.xcframework" >/dev/null

ls -ld -- "$PREFIX"
ls -l -- "$PREFIX"
ls -l -- "$PREFIX/Clibsodium.xcframework"

echo "Done!"

# Cleanup
rm -rf -- "$PREFIX/tmp"
make distclean >/dev/null
