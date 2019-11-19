// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'dlib.dart';
import 'types.dart';

/// Returns a new interpreter using the provided model and options, or null on
/// failure.
///
/// * `model` must be a valid model instance. The caller retains ownership of the
///   object, and can destroy it immediately after creating the interpreter; the
///   interpreter will maintain its own reference to the underlying model data.
/// * `optional_options` may be null. The caller retains ownership of the object,
///   and can safely destroy it immediately after creating the interpreter.
//
/// NOTE: The client *must* explicitly allocate tensors before attempting to
/// access input tensor data or invoke the interpreter.
Pointer<TfLiteInterpreter> Function(Pointer<TfLiteModel> model,
        Pointer<TfLiteInterpreterOptions> optional_options)
    TfLiteInterpreterCreate = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterCreate_native_t>>(
            'TfLiteInterpreterCreate')
        .asFunction();

typedef _TfLiteInterpreterCreate_native_t = Pointer<TfLiteInterpreter> Function(
    Pointer<TfLiteModel> model,
    Pointer<TfLiteInterpreterOptions> optional_options);

/// Destroys the interpreter.
void Function(Pointer<TfLiteInterpreter>) TfLiteInterpreterDelete = tflitelib
    .lookup<NativeFunction<_TfLiteInterpreterDelete_native_t>>(
        'TfLiteInterpreterDelete')
    .asFunction();

typedef _TfLiteInterpreterDelete_native_t = Void Function(
    Pointer<TfLiteInterpreter>);

/// Returns the number of input tensors associated with the model.
int Function(Pointer<TfLiteInterpreter>) TfLiteInterpreterGetInputTensorCount =
    tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterGetInputTensorCount_native_t>>(
            'TfLiteInterpreterGetInputTensorCount')
        .asFunction();

typedef _TfLiteInterpreterGetInputTensorCount_native_t = Int32 Function(
    Pointer<TfLiteInterpreter>);

/// Returns the tensor associated with the input index.
///
/// REQUIRES: 0 <= input_index < TfLiteInterpreterGetInputTensorCount(tensor)
Pointer<TfLiteTensor> Function(
        Pointer<TfLiteInterpreter> interpreter, int input_index)
    TfLiteInterpreterGetInputTensor = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterGetInputTensor_native_t>>(
            'TfLiteInterpreterGetInputTensor')
        .asFunction();

typedef _TfLiteInterpreterGetInputTensor_native_t = Pointer<TfLiteTensor>
    Function(Pointer<TfLiteInterpreter> interpreter, Int32 input_index);

/// Resizes the specified input tensor.
///
/// NOTE: After a resize, the client *must* explicitly allocate tensors before
/// attempting to access the resized tensor data or invoke the interpreter.
/// REQUIRES: 0 <= input_index < TfLiteInterpreterGetInputTensorCount(tensor)
/*TfLiteStatus*/
int Function(Pointer<TfLiteInterpreter> interpreter, int input_index,
        Pointer<Int32> input_dims, int input_dims_size)
    TfLiteInterpreterResizeInputTensor = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterResizeInputTensor_native_t>>(
            'TfLiteInterpreterResizeInputTensor')
        .asFunction();

typedef _TfLiteInterpreterResizeInputTensor_native_t
    = /*TfLiteStatus*/ Int32 Function(Pointer<TfLiteInterpreter> interpreter,
        Int32 input_index, Pointer<Int32> input_dims, Int32 input_dims_size);

/// Updates allocations for all tensors, resizing dependent tensors using the
/// specified input tensor dimensionality.
///
/// This is a relatively expensive operation, and need only be called after
/// creating the graph and/or resizing any inputs.
/*TfLiteStatus*/
int Function(Pointer<TfLiteInterpreter>) TfLiteInterpreterAllocateTensors =
    tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterAllocateTensors_native_t>>(
            'TfLiteInterpreterAllocateTensors')
        .asFunction();

typedef _TfLiteInterpreterAllocateTensors_native_t = /*TfLiteStatus*/ Int32
    Function(Pointer<TfLiteInterpreter>);

/// Runs inference for the loaded graph.
///
/// NOTE: It is possible that the interpreter is not in a ready state to
/// evaluate (e.g., if a ResizeInputTensor() has been performed without a call to
/// AllocateTensors()).
/*TfLiteStatus*/
int Function(Pointer<TfLiteInterpreter>) TfLiteInterpreterInvoke = tflitelib
    .lookup<NativeFunction<_TfLiteInterpreterInvoke_native_t>>(
        'TfLiteInterpreterInvoke')
    .asFunction();

typedef _TfLiteInterpreterInvoke_native_t = /*TfLiteStatus*/ Int32 Function(
    Pointer<TfLiteInterpreter>);

/// Returns the number of output tensors associated with the model.
int Function(
    Pointer<
        TfLiteInterpreter>) TfLiteInterpreterGetOutputTensorCount = tflitelib
    .lookup<NativeFunction<_TfLiteInterpreterGetOutputTensorCount_native_t>>(
        'TfLiteInterpreterGetOutputTensorCount')
    .asFunction();

typedef _TfLiteInterpreterGetOutputTensorCount_native_t = Int32 Function(
    Pointer<TfLiteInterpreter>);

/// Returns the tensor associated with the output index.
///
/// REQUIRES: 0 <= input_index < TfLiteInterpreterGetOutputTensorCount(tensor)
///
/// NOTE: The shape and underlying data buffer for output tensors may be not
/// be available until after the output tensor has been both sized and allocated.
/// In general, best practice is to interact with the output tensor *after*
/// calling TfLiteInterpreterInvoke().
Pointer<TfLiteTensor> Function(
        Pointer<TfLiteInterpreter> interpreter, int output_index)
    TfLiteInterpreterGetOutputTensor = tflitelib
        .lookup<NativeFunction<_TfLiteInterpreterGetOutputTensor_native_t>>(
            'TfLiteInterpreterGetOutputTensor')
        .asFunction();

typedef _TfLiteInterpreterGetOutputTensor_native_t = Pointer<TfLiteTensor>
    Function(Pointer<TfLiteInterpreter> interpreter, Int32 output_index);
