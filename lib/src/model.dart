// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'package:quiver/check.dart';

import 'bindings/utf8.dart';
import 'bindings/model.dart';
import 'bindings/types.dart';
import 'ffi/helper.dart';

/// TensorFlowLite model.
class Model {
  final Pointer<TFL_Model> _model;
  bool _deleted = false;

  Pointer<TFL_Model> get base => _model;

  Model._(this._model);

  /// Loads model from a file or throws if unsuccessful.
  factory Model.fromFile(String path) {
    final cpath = Utf8.toUtf8(path);
    final model = TFL_NewModelFromFile(cpath);
    cpath.free();
    checkArgument(isNotNull(model), message: 'Unable to create model.');
    return Model._(model);
  }

  /// Destroys the model instance.
  void delete() {
    checkState(!_deleted, message: 'Model already deleted.');
    TFL_DeleteModel(_model);
    _deleted = true;
  }

  // Unimplemented:
  // Model.fromBuffer => TFL_NewModel
}
