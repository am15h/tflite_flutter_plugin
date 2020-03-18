import 'dart:ffi';

import 'package:tflite_flutter_plugin/src/bindings/types.dart';
import 'package:tflite_flutter_plugin/src/delegate.dart';

/// NnApi Delegate for Android
class NnApiDelegate implements Delegate {
  @override
  Pointer<TfLiteDelegate> _delegate;
  bool _deleted = false;

  @override
  Pointer<TfLiteDelegate> get base => _delegate;

  NnApiDelegate._(this._delegate);

  factory NnApiDelegate() {
    //TODO: Implement bindings and classes for NnApiDelegate
    return null;
  }
}
