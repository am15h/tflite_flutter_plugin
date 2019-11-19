// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';
import 'types.dart';

/// Returns a model from the provided buffer, or null on failure.
Pointer<TfLiteModel> Function(Pointer<Void> data, int size) TfLiteNewModel =
    tflitelib
        .lookup<NativeFunction<_TfLiteNewModel_native_t>>('TfLiteNewModel')
        .asFunction();

typedef _TfLiteNewModel_native_t = Pointer<TfLiteModel> Function(
    Pointer<Void> data, Int32 size);

/// Returns a model from the provided file, or null on failure.
Pointer<TfLiteModel> Function(Pointer<Utf8> path) TfLiteModelCreateFromFile =
    tflitelib
        .lookup<NativeFunction<_TfLiteModelCreateFromFile_native_t>>(
            'TfLiteModelCreateFromFile')
        .asFunction();

typedef _TfLiteModelCreateFromFile_native_t = Pointer<TfLiteModel> Function(
    Pointer<Utf8> path);

/// Destroys the model instance.
void Function(Pointer<TfLiteModel>) TfLiteModelDelete = tflitelib
    .lookup<NativeFunction<_TfLiteModelDelete_native_t>>('TfLiteModelDelete')
    .asFunction();

typedef _TfLiteModelDelete_native_t = Void Function(Pointer<TfLiteModel>);
