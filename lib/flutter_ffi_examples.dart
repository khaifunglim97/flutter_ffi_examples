
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterFfiExamples {
  static const MethodChannel _channel = MethodChannel('flutter_ffi_examples');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
