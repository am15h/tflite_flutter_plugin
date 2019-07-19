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
Pointer<TFL_Interpreter> Function(Pointer<TFL_Model> model,
        Pointer<TFL_InterpreterOptions> optional_options) TFL_NewInterpreter =
    tflitelib
        .lookup<NativeFunction<_TFL_NewInterpreter_native_t>>(
            'TFL_NewInterpreter')
        .asFunction();
typedef _TFL_NewInterpreter_native_t = Pointer<TFL_Interpreter> Function(
    Pointer<TFL_Model> model, Pointer<TFL_InterpreterOptions> optional_options);

/// Destroys the interpreter.
void Function(Pointer<TFL_Interpreter>) TFL_DeleteInterpreter = tflitelib
    .lookup<NativeFunction<_TFL_DeleteInterpreter_native_t>>(
        'TFL_DeleteInterpreter')
    .asFunction();
typedef _TFL_DeleteInterpreter_native_t = Void Function(
    Pointer<TFL_Interpreter>);

/// Returns the number of input tensors associated with the model.
int Function(Pointer<TFL_Interpreter>) TFL_InterpreterGetInputTensorCount =
    tflitelib
        .lookup<NativeFunction<_TFL_InterpreterGetInputTensorCount_native_t>>(
            'TFL_InterpreterGetInputTensorCount')
        .asFunction();
typedef _TFL_InterpreterGetInputTensorCount_native_t = Int32 Function(
    Pointer<TFL_Interpreter>);

/// Returns the tensor associated with the input index.
///
/// REQUIRES: 0 <= input_index < TFL_InterpreterGetInputTensorCount(tensor)
Pointer<TFL_Tensor> Function(
        Pointer<TFL_Interpreter> interpreter, int input_index)
    TFL_InterpreterGetInputTensor = tflitelib
        .lookup<NativeFunction<_TFL_InterpreterGetInputTensor_native_t>>(
            'TFL_InterpreterGetInputTensor')
        .asFunction();
typedef _TFL_InterpreterGetInputTensor_native_t = Pointer<TFL_Tensor> Function(
    Pointer<TFL_Interpreter> interpreter, Int32 input_index);

/// Resizes the specified input tensor.
///
/// NOTE: After a resize, the client *must* explicitly allocate tensors before
/// attempting to access the resized tensor data or invoke the interpreter.
/// REQUIRES: 0 <= input_index < TFL_InterpreterGetInputTensorCount(tensor)
/*TFL_Status*/ int Function(Pointer<TFL_Interpreter> interpreter,
        int input_index, Pointer<Int32> input_dims, int input_dims_size)
    TFL_InterpreterResizeInputTensor = tflitelib
        .lookup<NativeFunction<_TFL_InterpreterResizeInputTensor_native_t>>(
            'TFL_InterpreterResizeInputTensor')
        .asFunction();
typedef _TFL_InterpreterResizeInputTensor_native_t
    = /*TFL_Status*/ Int32 Function(Pointer<TFL_Interpreter> interpreter,
        Int32 input_index, Pointer<Int32> input_dims, Int32 input_dims_size);

/// Updates allocations for all tensors, resizing dependent tensors using the
/// specified input tensor dimensionality.
///
/// This is a relatively expensive operation, and need only be called after
/// creating the graph and/or resizing any inputs.
/*TFL_Status*/ int Function(Pointer<TFL_Interpreter>)
    TFL_InterpreterAllocateTensors = tflitelib
        .lookup<NativeFunction<_TFL_InterpreterAllocateTensors_native_t>>(
            'TFL_InterpreterAllocateTensors')
        .asFunction();
typedef _TFL_InterpreterAllocateTensors_native_t = /*TFL_Status*/ Int32
    Function(Pointer<TFL_Interpreter>);

/// Runs inference for the loaded graph.
///
/// NOTE: It is possible that the interpreter is not in a ready state to
/// evaluate (e.g., if a ResizeInputTensor() has been performed without a call to
/// AllocateTensors()).
/*TFL_Status*/ int Function(Pointer<TFL_Interpreter>) TFL_InterpreterInvoke =
    tflitelib
        .lookup<NativeFunction<_TFL_InterpreterInvoke_native_t>>(
            'TFL_InterpreterInvoke')
        .asFunction();
typedef _TFL_InterpreterInvoke_native_t = /*TFL_Status*/ Int32 Function(
    Pointer<TFL_Interpreter>);

/// Returns the number of output tensors associated with the model.
int Function(Pointer<TFL_Interpreter>) TFL_InterpreterGetOutputTensorCount =
    tflitelib
        .lookup<NativeFunction<_TFL_InterpreterGetOutputTensorCount_native_t>>(
            'TFL_InterpreterGetOutputTensorCount')
        .asFunction();
typedef _TFL_InterpreterGetOutputTensorCount_native_t = Int32 Function(
    Pointer<TFL_Interpreter>);

/// Returns the tensor associated with the output index.
///
/// REQUIRES: 0 <= input_index < TFL_InterpreterGetOutputTensorCount(tensor)
///
/// NOTE: The shape and underlying data buffer for output tensors may be not
/// be available until after the output tensor has been both sized and allocated.
/// In general, best practice is to interact with the output tensor *after*
/// calling TFL_InterpreterInvoke().
Pointer<TFL_Tensor> Function(
        Pointer<TFL_Interpreter> interpreter, int output_index)
    TFL_InterpreterGetOutputTensor = tflitelib
        .lookup<NativeFunction<_TFL_InterpreterGetOutputTensor_native_t>>(
            'TFL_InterpreterGetOutputTensor')
        .asFunction();
typedef _TFL_InterpreterGetOutputTensor_native_t = Pointer<TFL_Tensor> Function(
    Pointer<TFL_Interpreter> interpreter, Int32 output_index);
