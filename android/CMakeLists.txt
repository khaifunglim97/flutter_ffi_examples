cmake_minimum_required(VERSION 3.4.1)

set(OPENCV_BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/opencv2")
set(OPENCV_INCLUDE_DIR "${OPENCV_BASE_DIR}/include/")
set(OPENCV_STATIC_LIB_DIR "${OPENCV_BASE_DIR}/${ANDROID_ABI}")
set(OPENCV_3RDPARTY_STATIC_LIB_DIR "${OPENCV_BASE_DIR}/3rdparty/${ANDROID_ABI}")

include_directories(${OPENCV_INCLUDE_DIR})

find_library(log-lib log)

add_library(highgui STATIC IMPORTED)
set_target_properties(highgui PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_highgui.a)

add_library(calib3d STATIC IMPORTED)
set_target_properties(calib3d PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_calib3d.a)

add_library(core STATIC IMPORTED)
set_target_properties(core PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_core.a)

add_library(dnn STATIC IMPORTED)
set_target_properties(dnn PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_dnn.a)

add_library(flann STATIC IMPORTED)
set_target_properties(flann PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_flann.a)

add_library(imgproc STATIC IMPORTED)
set_target_properties(imgproc PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_imgproc.a)

add_library(videoio STATIC IMPORTED)
set_target_properties(videoio PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_videoio.a)

add_library(imgcodecs STATIC IMPORTED)
set_target_properties(imgcodecs PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_imgcodecs.a)

add_library(features2d STATIC IMPORTED)
set_target_properties(features2d PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_features2d.a)

add_library(ml STATIC IMPORTED)
set_target_properties(ml PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_ml.a)

add_library(photo STATIC IMPORTED)
set_target_properties(photo PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_photo.a)

add_library(shape STATIC IMPORTED)
set_target_properties(shape PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_shape.a)

add_library(objdetect STATIC IMPORTED)
set_target_properties(objdetect PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_objdetect.a)

add_library(stitching STATIC IMPORTED)
set_target_properties(stitching PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_stitching.a)

add_library(wechat_qrcode STATIC IMPORTED)
set_target_properties(wechat_qrcode PROPERTIES IMPORTED_LOCATION ${OPENCV_STATIC_LIB_DIR}/libopencv_wechat_qrcode.a)

# https://stackoverflow.com/questions/41554511/how-to-add-cpufeatures-to-android-jni-cmake-gradle-build
include(AndroidNdkModules)
android_ndk_import_module_cpufeatures()

# https://stackoverflow.com/questions/39917056/undefined-references-in-static-opencv-libraries
# https://stackoverflow.com/questions/5395309/how-do-i-force-cmake-to-include-pthread-option-during-compilation
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

add_library(tbb STATIC IMPORTED)
set_target_properties(tbb PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/libtbb.a)

# https://stackoverflow.com/questions/41665655/what-is-carotene-o4t-and-why-does-it-cause-issues-with-compiling-a-program-using
# NOTE If still have errors - check `abiFilters` in build.gradle. You should *remove* the `x86` support, because tegra does NOT have packages for x86.
add_library(tegra_hal STATIC IMPORTED)
set_target_properties(tegra_hal PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/libtegra_hal.a)

# https://answers.opencv.org/question/210025/build-static-opencv-4-lib-in-macos/
add_library(ittnotify STATIC IMPORTED)
set_target_properties(ittnotify PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/libittnotify.a)


add_library(libopenjp2 STATIC IMPORTED)
set_target_properties(libopenjp2 PROPERTIES INTERFACE_COMPILE_DEFINITIONS "OPJ_STATIC" INTERFACE_LINK_LIBRARIES "\$<LINK_ONLY:m>")
add_library(libIlmImf STATIC IMPORTED)
set_target_properties(libIlmImf PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/libIlmImf.a)
add_library(liblibpng STATIC IMPORTED)
set_target_properties(liblibpng PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/liblibpng.a)
add_library(liblibtiff STATIC IMPORTED)
set_target_properties(liblibtiff PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/liblibtiff.a)
add_library(liblibwebp STATIC IMPORTED)
set_target_properties(liblibwebp PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/liblibwebp.a)
add_library(liblibjpeg-turbo STATIC IMPORTED)
set_target_properties(liblibjpeg-turbo PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/liblibjpeg-turbo.a)
add_library(liblibopenjp2 STATIC IMPORTED)
set_target_properties(liblibopenjp2 PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/liblibopenjp2.a)
add_library(liblibprotobuf STATIC IMPORTED)
set_target_properties(liblibprotobuf PROPERTIES IMPORTED_LOCATION ${OPENCV_3RDPARTY_STATIC_LIB_DIR}/liblibprotobuf.a)

add_library(libsodium STATIC IMPORTED)
set_target_properties(libsodium PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/deps/libsodium/include/
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/deps/libsodium/${ANDROID_ABI}/libsodium.a
)

add_library(libcmocka STATIC IMPORTED)
set_target_properties(libcmocka PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/deps/libcmocka/include/
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/deps/libcmocka/${ANDROID_ABI}/libcmocka-static.a
)

add_library( native_examples

        # Sets the library as a shared library.
        SHARED

        # Provides a relative path to your source file(s).
        ../ios/Classes/NativeOpencv.cpp
        ../ios/Classes/NativeLibsodium.cpp
        ../ios/Classes/NativeCmocka.c
        )

target_link_libraries(
        native_examples

        # Links the target library to the log library
        # included in the NDK.
        ${log-lib}

        libsodium
        libcmocka

        # NOTE Add whatever OpenCV module you need here!
        # i.e. If you see things like "error: undefined reference to xxx", have a try here

        # https://pullrequest.opencv.org/buildbot/export/opencv_releases/master-contrib_pack-contrib-android/
        wechat_qrcode
        dnn
        imgcodecs
        features2d
        calib3d
        imgproc
        highgui
        core

        tbb # NOTE tbb should be put AFTER core, otherwise will have error
        cpufeatures
        ittnotify
        tegra_hal # NOTE If still have errors - check `abiFilters` in build.gradle. You should *remove* the `x86` support, because tegra does NOT have packages for x86.
        Threads::Threads
        libIlmImf
        liblibpng
        liblibtiff
        liblibwebp
        liblibjpeg-turbo
        liblibopenjp2
        liblibprotobuf

        # https://stackoverflow.com/questions/43603178/undefined-reference-to-symbol-gzclose-with-cmake-and-opencv
        # https://stackoverflow.com/questions/9700414/compilation-problems-with-zlib
        -lz

        )