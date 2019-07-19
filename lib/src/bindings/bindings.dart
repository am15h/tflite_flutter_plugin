// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'utf8.dart';
import 'dlib.dart';

/// Version information for the TensorFlowLite library.
Pointer<Utf8> Function() TFL_Version = tflitelib
    .lookup<NativeFunction<_TFL_Version_native_t>>('TFL_Version')
    .asFunction();

typedef _TFL_Version_native_t = Pointer<Utf8> Function();
