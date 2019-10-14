// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';
import 'types.dart';

/// Returns a new interpreter options instances.
Pointer<TfLiteInterpreterOptions> Function() TfLiteInterpreterOptionsCreate =
    tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsCreate_native_t>>(
            'TfLiteInterpreterOptionsCreate')
        .asFunction();

typedef _TfLiteInterpreterOptionsCreate_native_t
    = Pointer<TfLiteInterpreterOptions> Function();

/// Destroys the interpreter options instance.
void Function(Pointer<TfLiteInterpreterOptions>)
    TfLiteInterpreterOptionsDelete = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsDelete_native_t>>(
            'TfLiteInterpreterOptionsDelete')
        .asFunction();

typedef _TfLiteInterpreterOptionsDelete_native_t = Void Function(
    Pointer<TfLiteInterpreterOptions>);

/// Sets the number of CPU threads to use for the interpreter.
void Function(
    Pointer<TfLiteInterpreterOptions> options,
    int
        threads) TfLiteInterpreterOptionsSetNumThreads = tflitelib
    .lookup<NativeFunction<_TfLiteInterpreterOptionsSetNumThreads_native_t>>(
        'TfLiteInterpreterOptionsSetNumThreads')
    .asFunction();

typedef _TfLiteInterpreterOptionsSetNumThreads_native_t = Void Function(
    Pointer<TfLiteInterpreterOptions> options, Int32 threads);

/// Sets a custom error reporter for interpreter execution.
//
/// * `reporter` takes the provided `user_data` object, as well as a C-style
///   format string and arg list (see also vprintf).
/// * `user_data` is optional. If provided, it is owned by the client and must
///   remain valid for the duration of the interpreter lifetime.
void Function(
  Pointer<TfLiteInterpreterOptions> options,
  Pointer<NativeFunction<Reporter>> reporter,
  Pointer<Void> user_data,
) TfLiteInterpreterOptionsSetErrorReporter = tflitelib
    .lookup<NativeFunction<_TfLiteInterpreterOptionsSetErrorReporter_native_t>>(
        'TfLiteInterpreterOptionsSetErrorReporter')
    .asFunction();

typedef _TfLiteInterpreterOptionsSetErrorReporter_native_t = Void Function(
  Pointer<TfLiteInterpreterOptions> options,
  Pointer<NativeFunction<Reporter>> reporter,
  Pointer<Void> user_data,
);

/// Custom error reporter function for interpreter execution.
typedef Reporter = Void Function(
    Pointer<Void> user_data,
    Pointer<Utf8> format,
    /*va_list*/ Pointer<Void> args);
