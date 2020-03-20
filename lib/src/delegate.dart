import 'dart:ffi';

import 'package:tflite_flutter_plugin/src/bindings/types.dart';

abstract class Delegate {
  /// Get pointer to TfLiteDelegate
  Pointer<TfLiteDelegate> get base;

  /// Destroys delegate instance
  void delete();
}
