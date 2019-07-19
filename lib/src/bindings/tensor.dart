// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'utf8.dart';
import 'dlib.dart';
import 'types.dart';

/// Returns the type of a tensor element.
TFL_Type TFL_TensorType(Pointer<TFL_Tensor> t) =>
    TFL_Type.values[_TFL_TensorType(t)];
int Function(Pointer<TFL_Tensor>) _TFL_TensorType = tflitelib
    .lookup<NativeFunction<_TFL_TensorType_native_t>>('TFL_TensorType')
    .asFunction();
typedef _TFL_TensorType_native_t = /*TFL_Type*/ Int32 Function(
    Pointer<TFL_Tensor>);

/// Returns the number of dimensions that the tensor has.
int Function(Pointer<TFL_Tensor>) TFL_TensorNumDims = tflitelib
    .lookup<NativeFunction<_TFL_TensorNumDims_native_t>>('TFL_TensorNumDims')
    .asFunction();
typedef _TFL_TensorNumDims_native_t = Int32 Function(Pointer<TFL_Tensor>);

/// Returns the length of the tensor in the 'dim_index' dimension.
///
/// REQUIRES: 0 <= dim_index < TFLiteTensorNumDims(tensor)
int Function(Pointer<TFL_Tensor> tensor, int dim_index) TFL_TensorDim =
    tflitelib
        .lookup<NativeFunction<_TFL_TensorDim_native_t>>('TFL_TensorDim')
        .asFunction();
typedef _TFL_TensorDim_native_t = Int32 Function(
    Pointer<TFL_Tensor> tensor, Int32 dim_index);

/// Returns the size of the underlying data in bytes.
int Function(Pointer<TFL_Tensor>) TFL_TensorByteSize = tflitelib
    .lookup<NativeFunction<_TFL_TensorByteSize_native_t>>('TFL_TensorByteSize')
    .asFunction();
typedef _TFL_TensorByteSize_native_t = Int32 Function(Pointer<TFL_Tensor>);

/// Returns a pointer to the underlying data buffer.
///
/// NOTE: The result may be null if tensors have not yet been allocated, e.g.,
/// if the Tensor has just been created or resized and `TFL_AllocateTensors()`
/// has yet to be called, or if the output tensor is dynamically sized and the
/// interpreter hasn't been invoked.
Pointer<Void> Function(Pointer<TFL_Tensor>) TFL_TensorData = tflitelib
    .lookup<NativeFunction<_TFL_TensorData_native_t>>('TFL_TensorData')
    .asFunction();
typedef _TFL_TensorData_native_t = Pointer<Void> Function(Pointer<TFL_Tensor>);

/// Returns the (null-terminated) name of the tensor.
Pointer<Utf8> Function(Pointer<TFL_Tensor>) TFL_TensorName = tflitelib
    .lookup<NativeFunction<_TFL_TensorName_native_t>>('TFL_TensorName')
    .asFunction();
typedef _TFL_TensorName_native_t = Pointer<Utf8> Function(Pointer<TFL_Tensor>);

/// Copies from the provided input buffer into the tensor's buffer.
///
/// REQUIRES: input_data_size == TFL_TensorByteSize(tensor)
/*TFL_Status*/ int Function(
  Pointer<TFL_Tensor> tensor,
  Pointer<Void> input_data,
  int input_data_size,
) TFL_TensorCopyFromBuffer = tflitelib
    .lookup<NativeFunction<_TFL_TensorCopyFromBuffer_native_t>>(
        'TFL_TensorCopyFromBuffer')
    .asFunction();
typedef _TFL_TensorCopyFromBuffer_native_t = /*TFL_Status*/ Int32 Function(
  Pointer<TFL_Tensor> tensor,
  Pointer<Void> input_data,
  Int32 input_data_size,
);

/// Copies to the provided output buffer from the tensor's buffer.
///
/// REQUIRES: output_data_size == TFL_TensorByteSize(tensor)
/*TFL_Status*/ int Function(
  Pointer<TFL_Tensor> tensor,
  Pointer<Void> output_data,
  int output_data_size,
) TFL_TensorCopyToBuffer = tflitelib
    .lookup<NativeFunction<_TFL_TensorCopyToBuffer_native_t>>(
        'TFL_TensorCopyToBuffer')
    .asFunction();
typedef _TFL_TensorCopyToBuffer_native_t = /*TFL_Status*/ Int32 Function(
  Pointer<TFL_Tensor> tensor,
  Pointer<Void> output_data,
  Int32 output_data_size,
);

// Unimplemented functions:
// TFL_TensorQuantizationParams
