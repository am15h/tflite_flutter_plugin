import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';
import 'types.dart';

/// Returns a new interpreter options instances.
Pointer<TfLiteInterpreterOptions> Function() tfLiteInterpreterOptionsCreate =
    tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsCreateNativeT>>(
            'TfLiteInterpreterOptionsCreate')
        .asFunction();

typedef _TfLiteInterpreterOptionsCreateNativeT
    = Pointer<TfLiteInterpreterOptions> Function();

/// Destroys the interpreter options instansymbolNamece.
void Function(Pointer<TfLiteInterpreterOptions>)
    tfLiteInterpreterOptionsDelete = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsDeleteNativeT>>(
            'TfLiteInterpreterOptionsDelete')
        .asFunction();

typedef _TfLiteInterpreterOptionsDeleteNativeT = Void Function(
    Pointer<TfLiteInterpreterOptions>);

/// Sets the number of CPU threads to use for the interpreter.
void Function(Pointer<TfLiteInterpreterOptions> options, int threads)
    tfLiteInterpreterOptionsSetNumThreads = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsSetNumThreadsNativeT>>(
            'TfLiteInterpreterOptionsSetNumThreads')
        .asFunction();

typedef _TfLiteInterpreterOptionsSetNumThreadsNativeT = Void Function(
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
  Pointer<Void> userData,
) tfLiteInterpreterOptionsSetErrorReporter = tflitelib
    .lookup<NativeFunction<_TfLiteInterpreterOptionsSetErrorReporterNativeT>>(
        'TfLiteInterpreterOptionsSetErrorReporter')
    .asFunction();

typedef _TfLiteInterpreterOptionsSetErrorReporterNativeT = Void Function(
  Pointer<TfLiteInterpreterOptions> options,
  Pointer<NativeFunction<Reporter>> reporter,
  Pointer<Void> userData,
);

/// Custom error reporter function for interpreter execution.
typedef Reporter = Void Function(Pointer<Void> userData, Pointer<Utf8> format,
    /*va_list*/ Pointer<Void> args);

void Function(Pointer<TfLiteInterpreterOptions> options,
        Pointer<TfLiteDelegate> delegate) tfLiteInterpreterOptionsAddDelegate =
    tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsAddDelegateNativeT>>(
            'TfLiteInterpreterOptionsAddDelegate')
        .asFunction();

typedef _TfLiteInterpreterOptionsAddDelegateNativeT = Void Function(
    Pointer<TfLiteInterpreterOptions> options,
    Pointer<TfLiteDelegate> delegate);

/// Enable or disable the NN API for the interpreter (true to enable).
void Function(Pointer<TfLiteInterpreterOptions> options, int enable)
    tfLiteInterpreterOptionsSetUseNNAPI = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterOptionsSetUseNNAPINativeT>>(
            'TfLiteInterpreterOptionsSetUseNNAPI')
        .asFunction();

typedef _TfLiteInterpreterOptionsSetUseNNAPINativeT = Void Function(
    Pointer<TfLiteInterpreterOptions> options, Int8 enable);
