import 'dart:ffi';

import '../dlib.dart';

import '../types.dart';

// CoreMl Delegate bindings

// Return a delegate that uses CoreML for ops execution.
// Must outlive the interpreter.
Pointer<TfLiteDelegate> Function(Pointer<TfLiteCoreMlDelegateOptions> options)
    tfliteCoreMlDelegateCreate = tflitelib
        .lookup<NativeFunction<_TfLiteCoreMlDelegateCreateNativeT>>(
            'TfLiteCoreMlDelegateCreate')
        .asFunction();

typedef _TfLiteCoreMlDelegateCreateNativeT = Pointer<TfLiteDelegate> Function(
    Pointer<TfLiteCoreMlDelegateOptions> options);

// Do any needed cleanup and delete 'delegate'.
void Function(Pointer<TfLiteDelegate>) tfliteCoreMlDelegateDelete = tflitelib
    .lookup<NativeFunction<_TfLiteCoreMlDelegateDeleteNativeT>>(
        'TfLiteCoreMlDelegateDelete')
    .asFunction();

typedef _TfLiteCoreMlDelegateDeleteNativeT = Void Function(
    Pointer<TfLiteDelegate> delegate);
