// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'utf8.dart';
import 'dlib.dart';
import 'types.dart';

/// Returns a new interpreter options instances.
Pointer<TFL_InterpreterOptions> Function() TFL_NewInterpreterOptions = tflitelib
    .lookup<NativeFunction<_TFL_NewInterpreterOptions_native_t>>(
        'TFL_NewInterpreterOptions')
    .asFunction();
typedef _TFL_NewInterpreterOptions_native_t = Pointer<TFL_InterpreterOptions>
    Function();

/// Destroys the interpreter options instance.
void Function(Pointer<TFL_InterpreterOptions>) TFL_DeleteInterpreterOptions =
    tflitelib
        .lookup<NativeFunction<_TFL_DeleteInterpreterOptions_native_t>>(
            'TFL_DeleteInterpreterOptions')
        .asFunction();
typedef _TFL_DeleteInterpreterOptions_native_t = Void Function(
    Pointer<TFL_InterpreterOptions>);

/// Sets the number of CPU threads to use for the interpreter.
void Function(Pointer<TFL_InterpreterOptions> options, int threads)
    TFL_InterpreterOptionsSetNumThreads = tflitelib
        .lookup<NativeFunction<_TFL_InterpreterOptionsSetNumThreads_native_t>>(
            'TFL_InterpreterOptionsSetNumThreads')
        .asFunction();
typedef _TFL_InterpreterOptionsSetNumThreads_native_t = Void Function(
    Pointer<TFL_InterpreterOptions> options, Int32 threads);

/// Sets a custom error reporter for interpreter execution.
//
/// * `reporter` takes the provided `user_data` object, as well as a C-style
///   format string and arg list (see also vprintf).
/// * `user_data` is optional. If provided, it is owned by the client and must
///   remain valid for the duration of the interpreter lifetime.
void Function(
  Pointer<TFL_InterpreterOptions> options,
  Pointer<NativeFunction<Reporter>> reporter,
  Pointer<Void> user_data,
) TFL_InterpreterOptionsSetErrorReporter = tflitelib
    .lookup<NativeFunction<_TFL_InterpreterOptionsSetErrorReporter_native_t>>(
        'TFL_InterpreterOptionsSetErrorReporter')
    .asFunction();
typedef _TFL_InterpreterOptionsSetErrorReporter_native_t = Void Function(
  Pointer<TFL_InterpreterOptions> options,
  Pointer<NativeFunction<Reporter>> reporter,
  Pointer<Void> user_data,
);

/// Custom error reporter function for interpreter execution.
typedef Reporter = Void Function(
    Pointer<Void> user_data,
    Pointer<Utf8> format,
    /*va_list*/ Pointer<Void> args);
