import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';
import 'package:tflite_flutter_plugin/src/bindings/types.dart';

import 'bindings/delegate.dart';

abstract class Delegate {
  Pointer<TfLiteDelegate> _delegate;

  /// Get pointer to TfLiteDelegate
  Pointer<TfLiteDelegate> get base => _delegate;
}

/// Metal Delegate for iOS
class TfLiteGpuDelegate implements Delegate {
  @override
  Pointer<TfLiteDelegate> _delegate;

  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  TfLiteGpuDelegate._(this._delegate);

  factory TfLiteGpuDelegate({TfLiteGpuDelegateOptions options}) =>
      TfLiteGpuDelegate._(TFLGpuDelegateCreate(options.base));

  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    TFLGpuDelegateDelete(_delegate);
    _deleted = true;
  }
}

/// Metal Delegate options
class TfLiteGpuDelegateOptions {
  Pointer<TFLGpuDelegateOptions> _options;
  bool _deleted = false;

  Pointer<TFLGpuDelegateOptions> get base => _options;

  TfLiteGpuDelegateOptions._(this._options);

  factory TfLiteGpuDelegateOptions(
      bool allowPrecisionLoss, TFLGpuDelegateWaitType waitType) {
    return TfLiteGpuDelegateOptions._(
        TFLGpuDelegateOptions.allocate(allowPrecisionLoss, waitType).addressOf);
  }

  void delete() {
    checkState(!_deleted, message: 'TfLiteGpuDelegate already deleted.');
    free(_options);
    _deleted = true;
  }
}
