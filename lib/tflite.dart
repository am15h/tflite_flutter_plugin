// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// TensorFlow Lite for Dart
library tflite;

import 'package:ffi/ffi.dart';

import 'src/bindings/bindings.dart';

export 'src/interpreter.dart';
export 'src/interpreter_options.dart';
export 'src/model.dart';
export 'src/tensor.dart';

/// tflite version information.
String get version => Utf8.fromUtf8(TfLiteVersion());
