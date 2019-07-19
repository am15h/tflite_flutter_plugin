// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:cli' as cli;
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate' show Isolate;
import 'package:path/path.dart' as path;

String _getPlatformSpecificName() {
  if (Platform.isLinux) {
    return 'libtensorflowlite_c-linux.so';
  }

  throw new Exception('Unsupported platform!');
}

/// TensorFlowLite C library.
DynamicLibrary tflitelib = () {
  final rootLibrary = 'package:tflite_native/tflite.dart';
  final blobs = cli
    .waitFor(Isolate.resolvePackageUri(Uri.parse('package:tflite_native/tflite.dart')))
    .resolve('src/blobs/');
  return DynamicLibrary.open(blobs.resolve(_getPlatformSpecificName()).toFilePath());
}();
