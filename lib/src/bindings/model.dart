import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';
import 'types.dart';

/// Returns a model from the provided buffer, or null on failure.
Pointer<TfLiteModel> Function(Pointer<Void> data, int size)
    tfLiteModelCreateFromBuffer = tflitelib
        .lookup<NativeFunction<_TfLiteModelCreateFromBufferNativeT>>(
            'TfLiteModelCreate')
        .asFunction();

typedef _TfLiteModelCreateFromBufferNativeT = Pointer<TfLiteModel> Function(
    Pointer<Void> data, Int32 size);

/// Returns a model from the provided file, or null on failure.
Pointer<TfLiteModel> Function(Pointer<Utf8> path) tfLiteModelCreateFromFile =
    tflitelib
        .lookup<NativeFunction<_TfLiteModelCreateFromFileNativeT>>(
            'TfLiteModelCreateFromFile')
        .asFunction();

typedef _TfLiteModelCreateFromFileNativeT = Pointer<TfLiteModel> Function(
    Pointer<Utf8> path);

/// Destroys the model instance.
void Function(Pointer<TfLiteModel>) tfLiteModelDelete = tflitelib
    .lookup<NativeFunction<_TfLiteModelDeleteNativeT>>('TfLiteModelDelete')
    .asFunction();

typedef _TfLiteModelDeleteNativeT = Void Function(Pointer<TfLiteModel>);
