// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:typed_data';
import 'package:quiver/check.dart';

import 'bindings/tensor.dart';
import 'bindings/types.dart';
import 'bindings/utf8.dart';
import 'ffi/helper.dart';

export 'bindings/types.dart' show TfLiteType;

/// TensorFlowLite tensor.
class Tensor {
  final Pointer<TfLiteTensor> _tensor;

  Tensor(this._tensor) {
    checkNotNull(_tensor);
  }

  /// Name of the tensor element.
  String get name => Utf8.fromUtf8(TfLiteTensorName(_tensor));

  /// Data type of the tensor element.
  TfLiteType get type => TfLiteTensorType(_tensor);

  /// Dimensions of the tensor.
  List<int> get shape => List.generate(
      TfLiteTensorNumDims(_tensor), (i) => TfLiteTensorDim(_tensor, i));

  /// Underlying data buffer as bytes.
  List<int> get data {
    final data = cast<Uint8>(TfLiteTensorData(_tensor));
    checkState(isNotNull(data), message: 'Tensor data is null.');
    return UnmodifiableUint8ListView(
        data.asExternalTypedData(count: TfLiteTensorByteSize(_tensor)));
  }

  /// Updates the underlying data buffer with new bytes.
  ///
  /// The size must match the size of the tensor.
  set data(List<int> bytes) {
    checkArgument(TfLiteTensorByteSize(_tensor) == bytes.length);
    final data = cast<Uint8>(TfLiteTensorData(_tensor));
    checkState(isNotNull(data), message: 'Tensor data is null.');
    bytes.asMap().forEach((i, byte) => data.elementAt(i).store(byte));
  }

  /// Copies the input bytes to the underlying data buffer.
  // TODO(shanehop): Prevent access if unallocated.
  void copyFrom(List<int> bytes) {
    final ptr = Pointer<Uint8>.allocate(count: bytes.length);
    bytes.asMap().forEach((i, byte) => ptr.elementAt(i).store(byte));
    checkState(TfLiteTensorCopyFromBuffer(_tensor, ptr.cast(), bytes.length) ==
        TfLiteStatus.ok);
    ptr.free();
  }

  /// Returns a copy of the underlying data buffer.
  // TODO(shanehop): Prevent access if unallocated.
  List<int> copyTo() {
    int size = TfLiteTensorByteSize(_tensor);
    final ptr = Pointer<Uint8>.allocate(count: size);
    checkState(
        TfLiteTensorCopyToBuffer(_tensor, ptr.cast(), size) == TfLiteStatus.ok);
    final bytes = List.generate(size, (i) => ptr.elementAt(i).load<int>(),
        growable: false);
    ptr.free();
    return bytes;
  }

  // Unimplemented:
  // TfLiteTensorQuantizationParams
}
