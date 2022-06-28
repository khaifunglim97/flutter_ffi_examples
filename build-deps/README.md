##Instructions to build

Run respective script files for libraries and platforms.

####Opencv
> For Android build, ensure Ninja is installed, with OpenJDK 8
> and JAVA_HOME is set.

> Build is only tested on NDK18 and CMake 3.10.2. Make sure 
> ANDROID_NDK_HOME is pointed to NDK18 with CMake 3.10.2 to avoid compile errors.
> 

####Libsodium
> `libsodium-apple-xcframework-modified.sh` is a modified
> script file based on the provided xcframework build script
> from libsodium dist-build to only build an armv7, arm64 iOS and 
> arm64, x86_64 iOS simulator xcframework.

> Build is only tested on NDK23. Make sure ANDROID_NDK_HOME is
> pointed to NDK23 to avoid compile errors.