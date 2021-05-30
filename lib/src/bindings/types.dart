import 'dart:ffi';

import 'package:ffi/ffi.dart';

/// Wraps a model interpreter.
class TfLiteInterpreter extends Opaque {}

/// Wraps customized interpreter configuration options.
class TfLiteInterpreterOptions extends Opaque {}

/// Wraps a loaded TensorFlowLite model.
class TfLiteModel extends Opaque {}

/// Wraps data associated with a graph tensor.
class TfLiteTensor extends Opaque {}

/// Wraps a TfLiteDelegate
class TfLiteDelegate extends Opaque {}

/// Wraps Quantization Params
class TfLiteQuantizationParams extends Struct {
  @Float()
  external double scale;

  @Int32()
  external int zeroPoint;

  @override
  String toString() {
    return 'TfLiteQuantizationParams{scale: $scale, zero_point: $zeroPoint}';
  }
}

/// Wraps gpu delegate options for iOS metal delegate
class TFLGpuDelegateOptions extends Struct {
  /// Allows to quantify tensors, downcast values, process in float16 etc.
  @Int32()
  external int allowPrecisionLoss;

  @Int32()
  external int waitType;

  // Allows execution of integer quantized models
  @Int32()
  external int enableQuantization;

  Pointer<TFLGpuDelegateOptions> get pointer {
    final result = calloc<TFLGpuDelegateOptions>();
    result.ref
      ..allowPrecisionLoss = allowPrecisionLoss
      ..waitType = waitType
      ..enableQuantization = enableQuantization;
    return result;
  }
}

/// Wraps TfLiteGpuDelegateOptionsV2 for android gpu delegate
class TfLiteGpuDelegateOptionsV2 extends Struct {
  /// When set to zero, computations are carried out in maximal possible
  /// precision. Otherwise, the GPU may quantify tensors, downcast values,
  /// process in FP16 to increase performance. For most models precision loss is
  /// warranted.
  /// [OBSOLETE]: to be removed
  @Int32()
  external int isPrecisionLossAllowed;

  /// Preference is defined in TfLiteGpuInferenceUsage.
  @Int32()
  external int inferencePreference;

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
  external int inferencePriority1;
  @Int32()
  external int inferencePriority2;
  @Int32()
  external int inferencePriority3;

  // Bitmask flags. See the comments in TfLiteGpuExperimentalFlags.
  @Int64()
  external int experimentalFlags;

  // A graph could have multiple partitions that can be delegated to the GPU.
  // This limits the maximum number of partitions to be delegated. By default,
  // it's set to 1 in TfLiteGpuDelegateOptionsV2Default().
  @Int32()
  external int maxDelegatedPartitions;

  Pointer<TfLiteGpuDelegateOptionsV2> get pointer {
    final result = calloc<TfLiteGpuDelegateOptionsV2>();
    result.ref
      ..isPrecisionLossAllowed = isPrecisionLossAllowed
      ..inferencePreference = inferencePreference
      ..inferencePriority1 = inferencePriority1
      ..inferencePriority2 = inferencePriority2
      ..inferencePriority3 = inferencePriority3
      ..experimentalFlags = experimentalFlags
      ..maxDelegatedPartitions = maxDelegatedPartitions;
    return result;
  }
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
  passive,

  /// Minimize latency. It uses active spinning instead of mutex and consumes
  /// additional CPU resources.
  active,

  /// Useful when the output is used with GPU pipeline then or if external
  /// command encoder is set.
  doNotWait,

  /// Tries to avoid GPU sleep mode.
  aggressive,
}

// android gpu delegate
/// Encapsulated compilation/runtime tradeoffs.
enum TfLiteGpuInferenceUsage {
  /// Delegate will be used only once, therefore, bootstrap/init time should
  /// be taken into account.
  ///TFLITE_GPU_INFERENCE_PREFERENCE_FAST_SINGLE_ANSWER,
  fastSingleAnswer,

  /// Prefer maximizing the throughput. Same delegate will be used repeatedly on
  /// multiple inputs.
  /// TFLITE_GPU_INFERENCE_PREFERENCE_SUSTAINED_SPEED,
  preferenceSustainSpeed,
}

enum TfLiteGpuInferencePriority {
  /// AUTO priority is needed when a single priority is the most important
  /// factor. For example,
  /// priority1 = MIN_LATENCY would result in the configuration that achieves
  /// maximum performance.
  /// TFLITE_GPU_INFERENCE_PRIORITY_AUTO,
  auto,

  /// TFLITE_GPU_INFERENCE_PRIORITY_MAX_PRECISION,
  maxPrecision,

  /// TFLITE_GPU_INFERENCE_PRIORITY_MIN_LATENCY,
  minLatency,

  /// TFLITE_GPU_INFERENCE_PRIORITY_MIN_MEMORY_USAGE,
  minMemoryUsage,
}

/// Used to toggle experimental flags used in the delegate. Note that this is a
/// bitmask, so the values should be 1, 2, 4, 8, ...etc.
enum TfLiteGpuExperimentalFlags {
  /// TFLITE_GPU_EXPERIMENTAL_FLAGS_NONE = 0,
  none,

  /// Enables inference on quantized models with the delegate.
  /// NOTE: This is enabled in TfLiteGpuDelegateOptionsV2Default.
  /// TFLITE_GPU_EXPERIMENTAL_FLAGS_ENABLE_QUANT = 1 << 0,
  enableQuant,

  /// Enforces execution with the provided backend.
  // TFLITE_GPU_EXPERIMENTAL_FLAGS_CL_ONLY = 1 << 1,
  clOnly,

  /// TFLITE_GPU_EXPERIMENTAL_FLAGS_GL_ONLY = 1 << 2
  glOnly,
}
