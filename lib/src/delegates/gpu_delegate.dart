import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';
import 'package:tflite_flutter_plugin/src/bindings/delegate.dart';
import 'package:tflite_flutter_plugin/src/bindings/types.dart';
import 'package:tflite_flutter_plugin/src/delegate.dart';

/// GPU delegate for Android
class GpuDelegateV2 implements Delegate {
  Pointer<TfLiteDelegate> _delegate;
  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  GpuDelegateV2._(this._delegate);

  factory GpuDelegateV2({GpuDelegateOptionsV2 options}) {
    if (options == null) {
      return GpuDelegateV2._(TfLiteGpuDelegateV2Create(
          GpuDelegateOptionsV2.GpuDelegateOptionsV2Default().base));
    }
    return GpuDelegateV2._(TfLiteGpuDelegateV2Create(options?.base));
  }
  @override
  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegateV2 already deleted.');
    TfLiteGpuDelegateV2Delete(_delegate);
    _deleted = true;
  }
}

/// GPU delegate options for Android
class GpuDelegateOptionsV2 {
  Pointer<TfLiteGpuDelegateOptionsV2> _options;
  bool _deleted = false;

  Pointer<TfLiteGpuDelegateOptionsV2> get base => _options;
  GpuDelegateOptionsV2._(this._options);

  factory GpuDelegateOptionsV2(
      bool isPrecisionLossAllowed,
      TfLiteGpuInferenceUsage inferencePreference,
      TfLiteGpuInferencePriority inferencePriority1,
      TfLiteGpuInferencePriority inferencePriority2,
      TfLiteGpuInferencePriority inferencePriority3) {
    return GpuDelegateOptionsV2._(TfLiteGpuDelegateOptionsV2.allocate(
            isPrecisionLossAllowed,
            inferencePreference,
            inferencePriority1,
            inferencePriority2,
            inferencePriority3)
        .addressOf);
  }

  factory GpuDelegateOptionsV2.GpuDelegateOptionsV2Default() {
    return GpuDelegateOptionsV2._(TfLiteGpuDelegateOptionsV2Default());
  }

  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegateV2 already deleted.');
    free(_options);
    _deleted = true;
  }
}
