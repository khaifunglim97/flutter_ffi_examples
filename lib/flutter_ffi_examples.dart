import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

final DynamicLibrary nativeExampleLib = Platform.isAndroid
    ? DynamicLibrary.open('libnative_examples.so')
    : DynamicLibrary.process();

extension Uint8ListBlobConversion on Uint8List {
  Pointer<Uint8> allocatePointer() {
    final blob = calloc<Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}

class FlutterFfiExamples {
  static const MethodChannel _channel = MethodChannel('flutter_ffi_examples');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static late final _opencvImgPixelsPtr = nativeExampleLib.lookup<
      NativeFunction<Int32 Function(
          Pointer<Uint8>, Int32)>>('opencv_img_pixels');

  static late final opencvImgPixels = _opencvImgPixelsPtr
      .asFunction<int Function(Pointer<Uint8>, int)>();

  static late final _libsodiumRandomPtr = nativeExampleLib.lookup<
      NativeFunction<Uint32 Function()>>('libsodium_random');

  static late final libsodiumRandom = _libsodiumRandomPtr
      .asFunction<int Function()>();

  static late final _cmockaNullTest = nativeExampleLib.lookup<
      NativeFunction<Int Function()>>('cmocka_null_test');

  static late final cmockaNullTest = _cmockaNullTest
      .asFunction<int Function()>();
}
