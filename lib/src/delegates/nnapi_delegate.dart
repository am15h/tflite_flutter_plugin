import 'dart:ffi';

import 'package:quiver/check.dart';
import 'package:tflite_flutter_plugin/src/bindings/delegate.dart';
import 'package:tflite_flutter_plugin/src/bindings/types.dart';
import 'package:tflite_flutter_plugin/src/delegate.dart';

/// NnApi Delegate for Android
class NnApiDelegate implements Delegate {
  Pointer<TfLiteDelegate> _delegate;
  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  NnApiDelegate._(this._delegate);

  factory NnApiDelegate() {
    return NnApiDelegate._(TfLiteStatefulNnApiDelegateCreate());
  }

  @override
  void delete() {
    checkState(!_deleted, message: 'TfLiteStatefulNnApiDelegate already deleted.');
    TfLiteStatefulNnApiDelegateDelete(_delegate);
    _deleted = true;
  }
}
