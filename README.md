[![Build Status](https://travis-ci.org/dart-lang/tflite_native.svg?branch=master)](https://travis-ci.org/dart-lang/tflite_native)

A Dart interface to [TensorFlow Lite (tflite)](https://www.tensorflow.org/lite) through
Dart's [foreign function interface (FFI)](https://dart.dev/server/c-interop).
This library wraps the experimental tflite
[C API](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/experimental/c/c_api.h).

This package supports desktop use cases (Linux, OSX, Windows, etc) and Flutter developers should consider
[flutter_tflite](https://github.com/shaqian/flutter_tflite). For example, this package locates a tflite
dynamic library through `Isolate.resolvePackageUri` which doesn't translate perfectly in the Flutter
context (see https://github.com/flutter/flutter/issues/14815).
