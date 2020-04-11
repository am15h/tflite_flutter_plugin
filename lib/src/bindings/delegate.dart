// iOS metal delegate

import 'dart:ffi';

import 'dlib.dart';

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

// android GPU delegate bindings

/// Creates a new delegate instance that need to be destroyed with
/// TfLiteGpuDelegateV2Delete when delegate is no longer used by TFLite.
///
/// This delegate encapsulates multiple GPU-acceleration APIs under the hood to
/// make use of the fastest available on a device.
///
/// When `options` is set to `nullptr`, then default options are used.
Pointer<TfLiteDelegate> Function(Pointer<TfLiteGpuDelegateOptionsV2> options)
    TfLiteGpuDelegateV2Create = tflitelib
        .lookup<NativeFunction<_TfLiteGpuDelegateV2Create_native_t>>(
            'TfLiteGpuDelegateV2Create')
        .asFunction();

typedef _TfLiteGpuDelegateV2Create_native_t = Pointer<TfLiteDelegate> Function(
    Pointer<TfLiteGpuDelegateOptionsV2> options);

/// Destroys a delegate created with `TfLiteGpuDelegateV2Create` call.
void Function(Pointer<TfLiteDelegate>) TfLiteGpuDelegateV2Delete = tflitelib
    .lookup<NativeFunction<_TFLGpuDelegateV2Delete_native_t>>(
        'TfLiteGpuDelegateV2Delete')
    .asFunction();

typedef _TFLGpuDelegateV2Delete_native_t = Void Function(
    Pointer<TfLiteDelegate> delegate);

/// Creates TfLiteGpuDelegateV2 with default options
Pointer<TfLiteGpuDelegateOptionsV2> Function()
    TfLiteGpuDelegateOptionsV2Default = tflitelib
        .lookup<
                NativeFunction<
                    _TfLiteTfLiteGpuDelegateOptionsV2Default_native_t>>(
            'TfLiteGpuDelegateOptionsV2Default')
        .asFunction();

typedef _TfLiteTfLiteGpuDelegateOptionsV2Default_native_t
    = Pointer<TfLiteGpuDelegateOptionsV2> Function();

/// Creates StatefulNnApiDelegate with default options
Pointer<TfLiteDelegate> Function() TfLiteStatefulNnApiDelegateCreate = tflitelib
    .lookup<NativeFunction<_TfLiteStatefulNnApiDelegateCreate_native_t>>(
        'TfLiteStatefulNnApiDelegateCreate')
    .asFunction();

typedef _TfLiteStatefulNnApiDelegateCreate_native_t = Pointer<TfLiteDelegate>
    Function();

/// Destroys a delegate created with `TfLiteStatefulNnApiDelegateCreate` call.
void Function(Pointer<TfLiteDelegate>) TfLiteStatefulNnApiDelegateDelete =
    tflitelib
        .lookup<NativeFunction<_TfLiteStatefulNnApiDelegateDelete_native_t>>(
            'TfLiteStatefulNnApiDelegateDelete')
        .asFunction();

typedef _TfLiteStatefulNnApiDelegateDelete_native_t = Void Function(
    Pointer<TfLiteDelegate> delegate);
