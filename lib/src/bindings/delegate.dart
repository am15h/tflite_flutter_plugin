// iOS metal delegate

import 'dart:ffi';

import 'package:tflite_flutter_plugin/src/bindings/dlib.dart';

import 'types.dart';

// iOS metal delegate bindings

/// Creates a new delegate instance that need to be destroyed with
/// `TFLDeleteTfLiteGpuDelegate` when delegate is no longer used by TFLite.
/// When `options` is set to `nullptr`, the following default values are used:
/// .precision_loss_allowed = false,
/// .wait_type = kPassive,
Pointer<TfLiteDelegate> Function(Pointer<TFLGpuDelegateOptions> options)
    TFLGpuDelegateCreate = tflitelib
        .lookup<NativeFunction<_TFLGpuDelegateCreate_native_t>>(
            'TFLGpuDelegateCreate')
        .asFunction();

typedef _TFLGpuDelegateCreate_native_t = Pointer<TfLiteDelegate> Function(
    Pointer<TFLGpuDelegateOptions> options);

/// Destroys a delegate created with `TFLGpuDelegateCreate` call.
void Function(Pointer<TfLiteDelegate>) TFLGpuDelegateDelete = tflitelib
    .lookup<NativeFunction<_TFLGpuDelegateDelete_native_t>>(
        'TFLGpuDelegateDelete')
    .asFunction();

typedef _TFLGpuDelegateDelete_native_t = Void Function(
    Pointer<TfLiteDelegate> delegate);
