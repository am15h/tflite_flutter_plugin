// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'utf8.dart';
import 'dlib.dart';
import 'types.dart';

/// Returns a model from the provided buffer, or null on failure.
Pointer<TFL_Model> Function(Pointer<Void> data, int size) TFL_NewModel =
    tflitelib
        .lookup<NativeFunction<_TFL_NewModel_native_t>>('TFL_NewModel')
        .asFunction();
typedef _TFL_NewModel_native_t = Pointer<TFL_Model> Function(
    Pointer<Void> data, Int32 size);

/// Returns a model from the provided file, or null on failure.
Pointer<TFL_Model> Function(Pointer<Utf8> path) TFL_NewModelFromFile = tflitelib
    .lookup<NativeFunction<_TFL_NewModelFromFile_native_t>>(
        'TFL_NewModelFromFile')
    .asFunction();
typedef _TFL_NewModelFromFile_native_t = Pointer<TFL_Model> Function(
    Pointer<Utf8> path);

/// Destroys the model instance.
void Function(Pointer<TFL_Model>) TFL_DeleteModel = tflitelib
    .lookup<NativeFunction<_TFL_DeleteModel_native_t>>('TFL_DeleteModel')
    .asFunction();
typedef _TFL_DeleteModel_native_t = Void Function(Pointer<TFL_Model>);
