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

/// Wraps TfLiteGpuDelegateOptionsV2 for android gpu delegate
class TfLiteGpuDelegateOptionsV2 extends Struct {
  /// When set to zero, computations are carried out in maximal possible
  /// precision. Otherwise, the GPU may quantify tensors, downcast values,
  /// process in FP16 to increase performance. For most models precision loss is
  /// warranted.
  /// [OBSOLETE]: to be removed
  @Int32()
  int is_precision_loss_allowed;

  /// Preference is defined in TfLiteGpuInferenceUsage.
  @Int32()
  int inference_preference;

  // Ordered priorities provide better control over desired semantics,
  // where priority(n) is more important than priority(n+1), therefore,
  // each time inference engine needs to make a decision, it uses
  // ordered priorities to do so.
  // For example:
  //   MAX_PRECISION at priority1 would not allow to decrease presision,
  //   but moving it to priority2 or priority3 would result in F16 calculation.
  //
  // Priority is defined in TfLiteGpuInferencePriority.
  // AUTO priority can only be used when higher priorities are fully specified.
  // For example:
  //   VALID:   priority1 = MIN_LATENCY, priority2 = AUTO, priority3 = AUTO
  //   VALID:   priority1 = MIN_LATENCY, priority2 = MAX_PRECISION,
  //            priority3 = AUTO
  //   INVALID: priority1 = AUTO, priority2 = MIN_LATENCY, priority3 = AUTO
  //   INVALID: priority1 = MIN_LATENCY, priority2 = AUTO,
  //            priority3 = MAX_PRECISION
  // Invalid priorities will result in error.
  @Int32()
  int inference_priority1;
  @Int32()
  int inference_priority2;
  @Int32()
  int inference_priority3;

  factory TfLiteGpuDelegateOptionsV2.allocate(
          bool isPrecisionLossAllowed,
          TfLiteGpuInferenceUsage inferencePreference,
          TfLiteGpuInferencePriority inferencePriority1,
          TfLiteGpuInferencePriority inferencePriority2,
          TfLiteGpuInferencePriority inferencePriority3) =>
      allocate<TfLiteGpuDelegateOptionsV2>().ref
        ..is_precision_loss_allowed = isPrecisionLossAllowed ? 1 : 0
        ..inference_preference = inferencePreference.index
        ..inference_priority1 = inferencePriority1.index
        ..inference_priority2 = inferencePriority2.index
        ..inference_priority3 = inferencePriority3.index;
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
  // ignore: constant_identifier_names
  TFLGpuDelegateWaitTypePassive,

  /// Minimize latency. It uses active spinning instead of mutex and consumes
  /// additional CPU resources.
  // ignore: constant_identifier_names
  TFLGpuDelegateWaitTypeActive,

  /// Useful when the output is used with GPU pipeline then or if external
  /// command encoder is set.
  // ignore: constant_identifier_names
  TFLGpuDelegateWaitTypeDoNotWait,

  /// Tries to avoid GPU sleep mode.
  // ignore: constant_identifier_names
  TFLGpuDelegateWaitTypeAggressive,
}

// android gpu delegate
/// Encapsulated compilation/runtime tradeoffs.
enum TfLiteGpuInferenceUsage {
  /// Delegate will be used only once, therefore, bootstrap/init time should
  /// be taken into account.
  // ignore: constant_identifier_names
  TFLITE_GPU_INFERENCE_PREFERENCE_FAST_SINGLE_ANSWER,

  /// Prefer maximizing the throughput. Same delegate will be used repeatedly on
  /// multiple inputs.
  // ignore: constant_identifier_names
  TFLITE_GPU_INFERENCE_PREFERENCE_SUSTAINED_SPEED,
}

enum TfLiteGpuInferencePriority {
  /// AUTO priority is needed when a single priority is the most important
  /// factor. For example,
  /// priority1 = MIN_LATENCY would result in the configuration that achieves
  /// maximum performance.
  // ignore: constant_identifier_names
  TFLITE_GPU_INFERENCE_PRIORITY_AUTO,
  // ignore: constant_identifier_names
  TFLITE_GPU_INFERENCE_PRIORITY_MAX_PRECISION,
  // ignore: constant_identifier_names
  TFLITE_GPU_INFERENCE_PRIORITY_MIN_LATENCY,
  // ignore: constant_identifier_names
  TFLITE_GPU_INFERENCE_PRIORITY_MIN_MEMORY_USAGE,
}
