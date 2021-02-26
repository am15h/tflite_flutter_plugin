// @dart=2.11
import 'dart:ffi';
import 'dart:io';

/// TensorFlowLite C library.
// ignore: missing_return
DynamicLibrary tflitelib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libtensorflowlite_c.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  }
}();
