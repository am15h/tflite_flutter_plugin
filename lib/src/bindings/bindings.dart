import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';

/// Version information for the TensorFlowLite library.
final Pointer<Utf8> Function() tfLiteVersion = tflitelib
    .lookup<NativeFunction<_TfLiteVersionNativeT>>('TfLiteVersion')
    .asFunction();

typedef _TfLiteVersionNativeT = Pointer<Utf8> Function();
