// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:quiver/check.dart';

import 'bindings/interpreter_options.dart';
import 'bindings/types.dart';

/// TensorFlowLite interpreter options.
class InterpreterOptions {
  final Pointer<TfLiteInterpreterOptions> _options;
  bool _deleted = false;

  Pointer<TfLiteInterpreterOptions> get base => _options;

  InterpreterOptions._(this._options);

  /// Creates a new options instance.
  factory InterpreterOptions() =>
      InterpreterOptions._(TfLiteInterpreterOptionsCreate());

  /// Destroys the options instance.
  void delete() {
    checkState(!_deleted, message: 'InterpreterOptions already deleted.');
    TfLiteInterpreterOptionsDelete(_options);
    _deleted = true;
  }

  /// Sets the number of CPU threads to use.
  set threads(int threads) =>
      TfLiteInterpreterOptionsSetNumThreads(_options, threads);

// Unimplemented:
// TfLiteInterpreterOptionsSetErrorReporter
}
