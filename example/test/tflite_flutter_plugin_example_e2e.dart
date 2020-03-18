// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter_plugin/tflite.dart' as tfl;
import 'package:e2e/e2e.dart';

final dataFileName = 'permute_uint8.tflite';
final missingFileName = 'missing.tflite';
final badFileName = 'bad_model.tflite';
final quantFileName = 'mobilenet_quant.tflite';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  test('version', () {
    expect(tfl.version, isNotEmpty);
  });

  test('interpreter from file', () async {
    final dataFile = await getFile(dataFileName);
    var interpreter = tfl.Interpreter.fromFile(dataFile);
    interpreter.close();
  });

  test('interpreter from buffer', () async {
    final buffer = await getBuffer(dataFileName);
    var interpreter = tfl.Interpreter.fromBuffer(buffer);
    interpreter.close();
  });

  test('interpreter from asset', () async {
    final interpreter = await tfl.Interpreter.fromAsset(dataFileName);
    interpreter.close();
  });

  group('interpreter options', () {
    test('default', () async {
      final dataFile = await getFile(dataFileName);

      var options = tfl.InterpreterOptions();
      var interpreter = tfl.Interpreter.fromFile(dataFile, options: options);
      options.delete();
      interpreter.allocateTensors();
      interpreter.invoke();
      interpreter.close();
    });

    test('threads', () async {
      final dataFile = await getFile(dataFileName);

      var options = tfl.InterpreterOptions()..threads = 1;
      var interpreter = tfl.Interpreter.fromFile(dataFile, options: options);
      options.delete();
      interpreter.allocateTensors();
      interpreter.invoke();
      interpreter.close();
    });
  });

  group('interpreter', () {
    tfl.Interpreter interpreter;
    setUp(() async {
      final dataFile = await getFile(dataFileName);
      interpreter = tfl.Interpreter.fromFile(dataFile);
    });
    tearDown(() => interpreter.close());

    test('allocate', () {
      interpreter.allocateTensors();
    });

    test('allocate throws if already allocated', () {
      interpreter.allocateTensors();
      expect(() => interpreter.allocateTensors(), throwsA(isStateError));
    });

    test('invoke throws if not allocated', () {
      expect(() => interpreter.invoke(), throwsA(isStateError));
    });

    test('invoke throws if not allocated after resized', () {
      interpreter.allocateTensors();
      interpreter.resizeInputTensor(0, [1, 2, 4]);
      expect(() => interpreter.invoke(), throwsA(isStateError));
    });

    test('invoke succeeds if allocated', () {
      interpreter.allocateTensors();
      interpreter.invoke();
    });

    test('get input tensors', () {
      expect(interpreter.getInputTensors(), hasLength(1));
    });

    test('get input tensor', () {
      expect(interpreter.getInputTensor(0), isNotNull);
    });

    test('get input tensor throws argument error', () {
      expect(() => interpreter.getInputTensor(33), throwsA(isArgumentError));
    });

    test('get input tensor index', () {
      var name = interpreter.getInputTensors()[0].name;
      expect(interpreter.getInputIndex(name), 0);
    });

    test('get input tensor index throws argument error', () {
      expect(() => interpreter.getInputIndex('abcd'), throwsA(isArgumentError));
    });

    test('get output tensors', () {
      expect(interpreter.getOutputTensors(), hasLength(1));
    });

    test('get output tensor', () {
      expect(interpreter.getOutputTensor(0), isNotNull);
    });

    test('get input tensor throws argument error', () {
      expect(() => interpreter.getOutputTensor(33), throwsA(isArgumentError));
    });

    test('get output tensor index', () {
      var name = interpreter.getOutputTensors()[0].name;
      expect(interpreter.getOutputIndex(name), 0);
    });

    test('get output tensor index throws argument error', () {
      expect(
          () => interpreter.getOutputIndex('abcd'), throwsA(isArgumentError));
    });

    test('resize input tensor', () {
      interpreter.resizeInputTensor(0, [2, 3, 5]);
      expect(interpreter.getInputTensors().single.shape, [2, 3, 5]);
    });

    group('tensors', () {
      List<tfl.Tensor> tensors;
      setUp(() => tensors = interpreter.getInputTensors());

      test('name', () {
        expect(tensors[0].name, 'input');
      });

      test('type', () {
        expect(tensors[0].type, tfl.TfLiteType.uint8);
      });

      test('shape', () {
        expect(tensors[0].shape, [1, 4]);
      });

      group('data', () {
        test('get throws if not allocated', () {
          expect(() => tensors[0].data, throwsA(isStateError));
        });

        test('get', () {
          interpreter.allocateTensors();
          expect(tensors[0].data, hasLength(4));
        });

        test('set throws if not allocated', () {
          expect(() => tensors[0].data = Uint8List.fromList(const [0, 0, 0, 0]),
              throwsA(isStateError));
        });

        test('set', () {
          interpreter.allocateTensors();
          tensors[0].data = Uint8List.fromList(const [0, 0, 0, 0]);
          expect(tensors[0].data, [0, 0, 0, 0]);
          tensors[0].data = Uint8List.fromList(const [0, 1, 10, 100]);
          expect(tensors[0].data, [0, 1, 10, 100]);
        });
      });

      /*group('quant', () {
        tfl.Interpreter interpreter;
        setUp(() async {
          final dataFile = await getPathOnDevice(quantFileName);
          interpreter = tfl.Interpreter.fromFile(dataFile);
        });
        tearDown(() => interpreter.delete());
        test('params', () {
          interpreter.allocateTensors();
          final tensor = interpreter.getInputTensor(0);
          print(tensor);
          print(tensor.params);
        });
      });*/
    });
  });
}

Future<File> getFile(String fileName) async {
  final appDir = await getTemporaryDirectory();
  final appPath = appDir.path;
  final fileOnDevice = File('$appPath/$fileName');
  final rawAssetFile = await rootBundle.load('assets/$fileName');
  final rawBytes = rawAssetFile.buffer.asUint8List();
  await fileOnDevice.writeAsBytes(rawBytes, flush: true);
  return fileOnDevice;
}

Future<String> getPathOnDevice(String assetFileName) async {
  final fileOnDevice = await getFile(assetFileName);
  return fileOnDevice.path;
}

Future<Uint8List> getBuffer(String assetFileName) async {
  final rawAssetFile = await rootBundle.load('assets/$assetFileName');
  final rawBytes = rawAssetFile.buffer.asUint8List();
  return rawBytes;
}
