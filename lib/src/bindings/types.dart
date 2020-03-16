// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

/// Wraps a model interpreter.
class TfLiteInterpreter extends Struct {}

/// Wraps customized interpreter configuration options.
class TfLiteInterpreterOptions extends Struct {}

/// Wraps a loaded TensorFlowLite model.
class TfLiteModel extends Struct {}

/// Wraps data associated with a graph tensor.
class TfLiteTensor extends Struct {}

/// Wraps a TfLiteDelegate
class TfLiteDelegate extends Struct {}

/// Wraps Quantization Params
class TfLiteQuantizationParams extends Struct {
  @Float()
  double scale;

  @Int32()
  int zero_point;

  @override
  String toString() {
    return 'TfLiteQuantizationParams{scale: $scale, zero_point: $zero_point}';
  }
}

/// Wraps gpu delegate options for iOS metal delegate
class TFLGpuDelegateOptions extends Struct {
  /// Allows to quantify tensors, downcast values, process in float16 etc.
  @Int32()
  int allow_precision_loss;

  @Int32()
  int wait_type;

  factory TFLGpuDelegateOptions.allocate(
          bool allowPrecisionLoss, TFLGpuDelegateWaitType waitType) =>
      allocate<TFLGpuDelegateOptions>().ref
        ..allow_precision_loss = allowPrecisionLoss ? 1 : 0
        ..wait_type = waitType.index;
}

/// Status of a TensorFlowLite function call.
class TfLiteStatus {
  static const ok = 0;
  static const error = 1;
}

/// Types supported by tensor.
enum TfLiteType {
  none,
  float32,
  int32,
  uint8,
  int64,
  string,
  bool,
  int16,
  complex64,
  int8,
  float16
}

/// iOS metal delegate wait types.
enum TFLGpuDelegateWaitType {
  /// waitUntilCompleted
  TFLGpuDelegateWaitTypePassive,

  /// Minimize latency. It uses active spinning instead of mutex and consumes
  /// additional CPU resources.
  TFLGpuDelegateWaitTypeActive,

  /// Useful when the output is used with GPU pipeline then or if external
  /// command encoder is set.
  TFLGpuDelegateWaitTypeDoNotWait,

  /// Tries to avoid GPU sleep mode.
  TFLGpuDelegateWaitTypeAggressive,
}
