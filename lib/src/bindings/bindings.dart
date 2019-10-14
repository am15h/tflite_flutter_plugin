// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';

/// Version information for the TensorFlowLite library.
Pointer<Utf8> Function() TfLiteVersion = tflitelib
    .lookup<NativeFunction<_TfLiteVersion_native_t>>('TfLiteVersion')
    .asFunction();

typedef _TfLiteVersion_native_t = Pointer<Utf8> Function();
