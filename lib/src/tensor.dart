// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:quiver/check.dart';
import 'package:tflite_flutter_plugin/src/quanitzation_params.dart';

import 'bindings/tensor.dart';
import 'bindings/types.dart';
import 'ffi/helper.dart';
import 'util/list_shape_extension.dart';

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
  Uint8List get data {
    final data = cast<Uint8>(TfLiteTensorData(_tensor));
//    checkState(isNotNull(data), message: 'Tensor data is null.');
    return UnmodifiableUint8ListView(
        data?.asTypedList(TfLiteTensorByteSize(_tensor)));
  }

  QuantizationParams get params {
    if (_tensor != null) {
      final ref = TfLiteTensorQuantizationParams(_tensor).ref;
      return QuantizationParams(ref.scale, ref.zero_point);
    } else {
      return QuantizationParams(0.0, 0);
    }
  }

  /// Updates the underlying data buffer with new bytes.
  ///
  /// The size must match the size of the tensor.
  set data(Uint8List bytes) {
    final tensorByteSize = TfLiteTensorByteSize(_tensor);
    checkArgument(tensorByteSize == bytes.length);
    final data = cast<Uint8>(TfLiteTensorData(_tensor));
    checkState(isNotNull(data), message: 'Tensor data is null.');
    final externalTypedData = data.asTypedList(tensorByteSize);
    externalTypedData.setRange(0, tensorByteSize, bytes);
  }

  /// Returns number of dimensions
  int numDimensions() {
    return TfLiteTensorNumDims(_tensor);
  }

  /// Returns the size, in bytes, of the tensor data.
  int numBytes() {
    return TfLiteTensorByteSize(_tensor);
  }

  /// Returns the number of elements in a flattened (1-D) view of the tensor.
  int numElements() {
    return computeNumElements(shape);
  }

  /// Returns the number of elements in a flattened (1-D) view of the tensor's shape.
  static int computeNumElements(List<int> shape) {
    var n = 1;
    for (var i = 0; i < shape.length; i++) {
      n *= shape[i];
    }
    return n;
  }

  /// Returns shape of an object as an int list
  static List<int> computeShapeOf(Object o) {
    var size = computeNumDimensions(o);
    var dimensions = List.filled(size, 0, growable: false);
    fillShape(o, 0, dimensions);
    return dimensions;
  }

  /// Returns the number of dimensions of a multi-dimensional array, otherwise 0.
  static int computeNumDimensions(Object o) {
    if (o == null || !(o is List)) {
      return 0;
    }
    if ((o as List).isEmpty) {
      throw ArgumentError('Array lengths cannot be 0.');
    }
    return 1 + computeNumDimensions((o as List).elementAt(0));
  }

  /// Recursively populates the shape dimensions for a given (multi-dimensional) array)
  static void fillShape(Object o, int dim, List<int> shape) {
    if (shape == null || dim == shape.length) {
      return;
    }
    final len = (o as List).length;
    if (shape[dim] == 0) {
      shape[dim] = len;
    } else if (shape[dim] != len) {
      throw ArgumentError(
          'Mismatched lengths ${shape[dim]} and $len in dimension $dim');
    }
    for (var i = 0; i < len; ++i) {
      fillShape((o as List).elementAt(0), dim + 1, shape);
    }
  }

  /// Returns data type of given object
  static TfLiteType dataTypeOf(Object o) {
    var c;
    while (o is List) {
      o = (o as List).elementAt(0);
    }
    c = o;
    if (c is double) {
      return TfLiteType.float32;
    } else if (c is int) {
      return TfLiteType.int32;
    } else if (c is String) {
      return TfLiteType.string;
    } else if (c is bool) {
      return TfLiteType.bool;
    }
    throw ArgumentError(
        'DataType error: cannot resolve DataType of ${o.runtimeType}');
  }

  void setTo(Object src) {
    var bytes = _convertObjectToBytes(src);
    var size = bytes.length;
    final ptr = allocate<Uint8>(count: size);
    checkState(isNotNull(ptr), message: 'unallocated');
    final externalTypedData = ptr.asTypedList(size);
    externalTypedData.setRange(0, bytes.length, bytes);
    checkState(TfLiteTensorCopyFromBuffer(_tensor, ptr.cast(), bytes.length) ==
        TfLiteStatus.ok);
    free(ptr);
  }

  Object copyTo(Object dst) {
    var size = TfLiteTensorByteSize(_tensor);
    final ptr = allocate<Uint8>(count: size);
    checkState(isNotNull(ptr), message: 'unallocated');
    final externalTypedData = ptr.asTypedList(size);
    checkState(
        TfLiteTensorCopyToBuffer(_tensor, ptr.cast(), size) == TfLiteStatus.ok);
    // Clone the data, because once `free(ptr)`, `externalTypedData` will be
    // volatile
    final bytes = externalTypedData.sublist(0);
    data = bytes;
    final obj = _convertBytesToObject(bytes);
    free(ptr);
    if (obj is List && dst is List) {
      _duplicateList(obj, dst);
    } else {
      dst = obj;
    }
    return obj;
  }

  Uint8List _convertObjectToBytes(Object o) {
    if (o is Uint8List) {
      return o;
    }
    var bytes = <int>[];
    if (o is List) {
      for (var e in o) {
        bytes.addAll(_convertObjectToBytes(e));
      }
    } else {
      return _convertElementToBytes(o);
    }
    return Uint8List.fromList(bytes);
  }

  Uint8List _convertElementToBytes(Object o) {
    //TODO: add conversions for rest of the types
    if (type == TfLiteType.float32) {
      if (o is double) {
        var buffer = Uint8List(4).buffer;
        var bdata = ByteData.view(buffer);
        bdata.setFloat32(0, o);
        return buffer.asUint8List();
      } else {
        throw ArgumentError(
            'The input element is ${o.runtimeType} while tensor data type is ${TfLiteType.float32}');
      }
    } else if (type == TfLiteType.int32) {
      if (o is int) {
        var buffer = Uint8List(4).buffer;
        var bdata = ByteData.view(buffer);
        bdata.setInt32(0, o);
        return buffer.asUint8List();
      } else {
        throw ArgumentError(
            'The input element is ${o.runtimeType} while tensor data type is ${TfLiteType.int32}');
      }
    } else {
      throw ArgumentError(
          'The input data type ${o.runtimeType} is unsupported');
    }
  }

  Object _convertBytesToObject(Uint8List bytes) {
    // stores flattened data
    var list = [];
    //TODO: add conversions for the rest of the types
    if (type == TfLiteType.int32) {
      for (var i = 0; i < bytes.length; i += 4) {
        list.add(ByteData.view(bytes.buffer).getInt32(i));
      }
    } else if (type == TfLiteType.float32) {
      for (var i = 0; i < bytes.length; i += 4) {
        list.add(ByteData.view(bytes.buffer).getFloat32(i));
      }
    }
    return list.reshape(shape);
  }

  void _duplicateList(List obj, List dst) {
    var objShape = obj.shape;
    var dstShape = dst.shape;
    var equal = true;
    if (objShape.length == dst.shape.length) {
      for (var i = 0; i < objShape.length; i++) {
        if (objShape[i] != dstShape[i]) {
          equal = false;
          break;
        }
      }
    } else {
      equal = false;
    }
    if (equal == false) {
      throw ArgumentError(
          'Output object shape mismatch, interpreter returned output of shape: ${obj.shape} while shape of output provided as argument in run is: ${dst.shape}');
    }
    for (var i = 0; i < obj.length; i++) {
      dst[i] = obj[i];
    }
  }

  @override
  String toString() {
    return 'Tensor{_tensor: $_tensor, name: $name, type: $type, shape: $shape, data: ${data.sublist(0, 10)} ${data.length}';
  }
}
