import 'dart:async';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffi_examples/flutter_ffi_examples.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late Uint8List _preOpencvPixels;
  int _numPixels = 0;
  int _randomNum = -1;
  int _cmockaTest = -1;
  String _eigenMatInfo = "NULL";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterFfiExamples.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // OpenCV
    ByteData bytesData = await rootBundle.load('images/sample_photo.webp');
    _preOpencvPixels = bytesData.buffer.asUint8List(
        bytesData.offsetInBytes, bytesData.lengthInBytes);

    final _preOpencvPtr = _preOpencvPixels.allocatePointer();
    int numPixels = FlutterFfiExamples.opencvImgPixels(
        _preOpencvPtr, _preOpencvPixels.length);
    calloc.free(_preOpencvPtr);

    // Libsodium
    int randomNum = FlutterFfiExamples.libsodiumRandom();

    // Cmocka
    int cmockaTest = FlutterFfiExamples.cmockaNullTest();

    // Eigen
    String eigenMatInfo =
      FlutterFfiExamples.eigenMatrix().toDartString();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _numPixels = numPixels;
      _randomNum = randomNum;
      _cmockaTest = cmockaTest;
      _eigenMatInfo = eigenMatInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Number of pixels for sample image: $_numPixels\n'),
              Text('Random number generated: $_randomNum\n'),
              Text('Cmocka test result: $_cmockaTest\n'),
              Text('Eigen matrix: $_eigenMatInfo\n'),
            ],
          ),
        ),
      ),
    );
  }
}
