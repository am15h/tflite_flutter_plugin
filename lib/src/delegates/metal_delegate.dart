import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';
import 'package:tflite_flutter_plugin/src/bindings/delegate.dart';
import 'package:tflite_flutter_plugin/src/bindings/types.dart';
import 'package:tflite_flutter_plugin/src/delegate.dart';

/// Metal Delegate for iOS
class GpuDelegate implements Delegate {
  Pointer<TfLiteDelegate> _delegate;
  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  GpuDelegate._(this._delegate);

  factory GpuDelegate({GpuDelegateOptions options}) =>
      GpuDelegate._(TFLGpuDelegateCreate(options?.base));

  @override
  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    TFLGpuDelegateDelete(_delegate);
    _deleted = true;
  }
}

/// Metal Delegate options
class GpuDelegateOptions {
  Pointer<TFLGpuDelegateOptions> _options;
  bool _deleted = false;

  Pointer<TFLGpuDelegateOptions> get base => _options;

  GpuDelegateOptions._(this._options);

  factory GpuDelegateOptions(
      bool allowPrecisionLoss, TFLGpuDelegateWaitType waitType) {
    return GpuDelegateOptions._(
        TFLGpuDelegateOptions.allocate(allowPrecisionLoss, waitType).addressOf);
  }

  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    free(_options);
    _deleted = true;
  }
}
