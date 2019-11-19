// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dlib.dart';
import 'types.dart';

/// Returns the type of a tensor element.
TfLiteType TfLiteTensorType(Pointer<TfLiteTensor> t) =>
    TfLiteType.values[_TfLiteTensorType(t)];
int Function(Pointer<TfLiteTensor>) _TfLiteTensorType = tflitelib
    .lookup<NativeFunction<_TfLiteTensorType_native_t>>('TfLiteTensorType')
    .asFunction();

typedef _TfLiteTensorType_native_t = /*TfLiteType*/ Int32 Function(
    Pointer<TfLiteTensor>);

/// Returns the number of dimensions that the tensor has.
int Function(Pointer<TfLiteTensor>) TfLiteTensorNumDims = tflitelib
    .lookup<NativeFunction<_TfLiteTensorNumDims_native_t>>(
        'TfLiteTensorNumDims')
    .asFunction();

typedef _TfLiteTensorNumDims_native_t = Int32 Function(Pointer<TfLiteTensor>);

/// Returns the length of the tensor in the 'dim_index' dimension.
///
/// REQUIRES: 0 <= dim_index < TFLiteTensorNumDims(tensor)
int Function(Pointer<TfLiteTensor> tensor, int dim_index) TfLiteTensorDim =
    tflitelib
        .lookup<NativeFunction<_TfLiteTensorDim_native_t>>('TfLiteTensorDim')
        .asFunction();

typedef _TfLiteTensorDim_native_t = Int32 Function(
    Pointer<TfLiteTensor> tensor, Int32 dim_index);

/// Returns the size of the underlying data in bytes.
int Function(Pointer<TfLiteTensor>) TfLiteTensorByteSize = tflitelib
    .lookup<NativeFunction<_TfLiteTensorByteSize_native_t>>(
        'TfLiteTensorByteSize')
    .asFunction();

typedef _TfLiteTensorByteSize_native_t = Int32 Function(Pointer<TfLiteTensor>);

/// Returns a pointer to the underlying data buffer.
///
/// NOTE: The result may be null if tensors have not yet been allocated, e.g.,
/// if the Tensor has just been created or resized and `TfLiteAllocateTensors()`
/// has yet to be called, or if the output tensor is dynamically sized and the
/// interpreter hasn't been invoked.
Pointer<Void> Function(Pointer<TfLiteTensor>) TfLiteTensorData = tflitelib
    .lookup<NativeFunction<_TfLiteTensorData_native_t>>('TfLiteTensorData')
    .asFunction();

typedef _TfLiteTensorData_native_t = Pointer<Void> Function(
    Pointer<TfLiteTensor>);

/// Returns the (null-terminated) name of the tensor.
Pointer<Utf8> Function(Pointer<TfLiteTensor>) TfLiteTensorName = tflitelib
    .lookup<NativeFunction<_TfLiteTensorName_native_t>>('TfLiteTensorName')
    .asFunction();

typedef _TfLiteTensorName_native_t = Pointer<Utf8> Function(
    Pointer<TfLiteTensor>);

/// Copies from the provided input buffer into the tensor's buffer.
///
/// REQUIRES: input_data_size == TfLiteTensorByteSize(tensor)
/*TfLiteStatus*/
int Function(
  Pointer<TfLiteTensor> tensor,
  Pointer<Void> input_data,
  int input_data_size,
) TfLiteTensorCopyFromBuffer = tflitelib
    .lookup<NativeFunction<_TfLiteTensorCopyFromBuffer_native_t>>(
        'TfLiteTensorCopyFromBuffer')
    .asFunction();

typedef _TfLiteTensorCopyFromBuffer_native_t = /*TfLiteStatus*/ Int32 Function(
  Pointer<TfLiteTensor> tensor,
  Pointer<Void> input_data,
  Int32 input_data_size,
);

/// Copies to the provided output buffer from the tensor's buffer.
///
/// REQUIRES: output_data_size == TfLiteTensorByteSize(tensor)
/*TfLiteStatus*/
int Function(
  Pointer<TfLiteTensor> tensor,
  Pointer<Void> output_data,
  int output_data_size,
) TfLiteTensorCopyToBuffer = tflitelib
    .lookup<NativeFunction<_TfLiteTensorCopyToBuffer_native_t>>(
        'TfLiteTensorCopyToBuffer')
    .asFunction();

typedef _TfLiteTensorCopyToBuffer_native_t = /*TfLiteStatus*/ Int32 Function(
  Pointer<TfLiteTensor> tensor,
  Pointer<Void> output_data,
  Int32 output_data_size,
);

// Unimplemented functions:
// TfLiteTensorQuantizationParams
