// @dart=2.11
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';
import '../bindings/delegate.dart';
import '../bindings/types.dart';
import '../delegate.dart';

/// Metal Delegate for iOS
class GpuDelegate implements Delegate {
  Pointer<TfLiteDelegate> _delegate;
  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  GpuDelegate._(this._delegate);

  factory GpuDelegate({GpuDelegateOptions options}) =>
      GpuDelegate._(tflGpuDelegateCreate(options?.base));

  @override
  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    tflGpuDelegateDelete(_delegate);
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
        TFLGpuDelegateOptions.allocate(allowPrecisionLoss, waitType));
  }

  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    calloc.free(_options);
    _deleted = true;
  }
}
