import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';
import '../bindings/metal_delegate.dart';
import '../bindings/types.dart';
import '../delegate.dart';

/// Metal Delegate for iOS
class GpuDelegate implements Delegate {
  Pointer<TfLiteDelegate> _delegate;
  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  GpuDelegate._(this._delegate);

  factory GpuDelegate({GpuDelegateOptions? options}) =>
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

  factory GpuDelegateOptions({
    bool allowPrecisionLoss = false,
    TFLGpuDelegateWaitType waitType = TFLGpuDelegateWaitType.passive,
    bool enableQuantization = true,
  }) {
    var options = tFLGpuDelegateOptionsDefault();
    options
      ..allowPrecisionLoss = allowPrecisionLoss ? 1 : 0
      ..waitType = waitType.index
      ..enableQuantization = enableQuantization ? 1 : 0;
    return GpuDelegateOptions._(options.pointer);
  }

  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    calloc.free(_options);
    _deleted = true;
  }
}
