import 'dart:ffi';

import 'package:tflite_flutter_plugin/src/bindings/types.dart';

abstract class Delegate {
  Pointer<TfLiteDelegate> _delegate;

  /// Get pointer to TfLiteDelegate
  Pointer<TfLiteDelegate> get base => _delegate;
}
