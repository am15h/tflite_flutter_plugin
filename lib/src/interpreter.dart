// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';

import 'bindings/interpreter.dart';
import 'bindings/types.dart';
import 'ffi/helper.dart';
import 'interpreter_options.dart';
import 'model.dart';
import 'tensor.dart';

/// TensorFlowLite interpreter for running inference on a model.
class Interpreter {
  final Pointer<TfLiteInterpreter> _interpreter;
  bool _deleted = false;
  bool _allocated = false;

  Interpreter._(this._interpreter);

  /// Creates interpreter from model or throws if unsuccessful.
  factory Interpreter(Model model, {InterpreterOptions options}) {
    final interpreter = TfLiteInterpreterCreate(
        model.base, options?.base ?? cast<TfLiteInterpreterOptions>(nullptr));
    checkArgument(isNotNull(interpreter),
        message: 'Unable to create interpreter.');
    return Interpreter._(interpreter);
  }

  /// Creates interpreter from a model file or throws if unsuccessful.
  factory Interpreter.fromFile(String file, {InterpreterOptions options}) {
    final model = Model.fromFile(file);
    final interpreter = Interpreter(model, options: options);
    model.delete();
    return interpreter;
  }

  /// Destroys the model instance.
  void delete() {
    checkState(!_deleted, message: 'Interpreter already deleted.');
    TfLiteInterpreterDelete(_interpreter);
    _deleted = true;
  }

  /// Updates allocations for all tensors.
  void allocateTensors() {
    checkState(!_allocated, message: 'Interpreter already allocated.');
    checkState(
        TfLiteInterpreterAllocateTensors(_interpreter) == TfLiteStatus.ok);
    _allocated = true;
  }

  /// Runs inference for the loaded graph.
  void invoke() {
    checkState(_allocated, message: 'Interpreter not allocated.');
    checkState(TfLiteInterpreterInvoke(_interpreter) == TfLiteStatus.ok);
  }

  /// Gets all input tensors associated with the model.
  List<Tensor> getInputTensors() => List.generate(
      TfLiteInterpreterGetInputTensorCount(_interpreter),
      (i) => Tensor(TfLiteInterpreterGetInputTensor(_interpreter, i)),
      growable: false);

  /// Gets all output tensors associated with the model.
  List<Tensor> getOutputTensors() => List.generate(
      TfLiteInterpreterGetOutputTensorCount(_interpreter),
      (i) => Tensor(TfLiteInterpreterGetOutputTensor(_interpreter, i)),
      growable: false);

  /// Resize input tensor for the given tensor index. `allocateTensors` must be called again afterward.
  void resizeInputTensor(int tensorIndex, List<int> shape) {
    final dimensionSize = shape.length;
    final dimensions = allocate<Int32>(count: dimensionSize);
    final externalTypedData = dimensions.asTypedList(dimensionSize);
    externalTypedData.setRange(0, dimensionSize, shape);
    final status = TfLiteInterpreterResizeInputTensor(
        _interpreter, tensorIndex, dimensions, dimensionSize);
    free(dimensions);
    checkState(status == TfLiteStatus.ok);
    _allocated = false;
  }
}
