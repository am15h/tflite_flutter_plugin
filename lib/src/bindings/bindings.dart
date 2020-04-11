import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';

/// Version information for the TensorFlowLite library.
Pointer<Utf8> Function() TfLiteVersion = tflitelib
    .lookup<NativeFunction<_TfLiteVersion_native_t>>('TfLiteVersion')
    .asFunction();

typedef _TfLiteVersion_native_t = Pointer<Utf8> Function();
