// iOS metal delegate

import 'dart:ffi';

import '../dlib.dart';

import '../types.dart';

// Android GPU delegate bindings

/// Creates a new delegate instance that need to be destroyed with
/// TfLiteGpuDelegateV2Delete when delegate is no longer used by TFLite.
///
/// This delegate encapsulates multiple GPU-acceleration APIs under the hood to
/// make use of the fastest available on a device.
///
/// When `options` is set to `nullptr`, then default options are used.
Pointer<TfLiteDelegate> Function(Pointer<TfLiteGpuDelegateOptionsV2> options)
    tfLiteGpuDelegateV2Create = tflitelib
        .lookup<NativeFunction<_TfLiteGpuDelegateV2CreateNativeT>>(
            'TfLiteGpuDelegateV2Create')
        .asFunction();

typedef _TfLiteGpuDelegateV2CreateNativeT = Pointer<TfLiteDelegate> Function(
    Pointer<TfLiteGpuDelegateOptionsV2> options);

/// Destroys a delegate created with `TfLiteGpuDelegateV2Create` call.
void Function(Pointer<TfLiteDelegate>) tfLiteGpuDelegateV2Delete = tflitelib
    .lookup<NativeFunction<_TFLGpuDelegateV2DeleteNativeT>>(
        'TfLiteGpuDelegateV2Delete')
    .asFunction();

typedef _TFLGpuDelegateV2DeleteNativeT = Void Function(
    Pointer<TfLiteDelegate> delegate);

/// Creates TfLiteGpuDelegateV2 with default options
TfLiteGpuDelegateOptionsV2 Function() tfLiteGpuDelegateOptionsV2Default =
    tflitelib
        .lookup<
                NativeFunction<
                    _TfLiteTfLiteGpuDelegateOptionsV2DefaultNativeT>>(
            'TfLiteGpuDelegateOptionsV2Default')
        .asFunction();

typedef _TfLiteTfLiteGpuDelegateOptionsV2DefaultNativeT
    = TfLiteGpuDelegateOptionsV2 Function();
