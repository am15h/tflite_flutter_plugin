// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:tflite_native/tflite.dart' as tfl;

final dataDir = path.join(Directory.current.path, 'testdata');
final dataFile = '$dataDir/permute_uint8.tflite';
final missingFile = '$dataDir/missing.tflite';
final badFile = '$dataDir/bad_model.tflite';

void main() {
  test('version', () {
    expect(tfl.version, isNotEmpty);
  });

  group('model', () {
    test('from file', () {
      var model = tfl.Model.fromFile(dataFile);
      model.delete();
    });

    test('deleting a deleted model throws', () {
      var model = tfl.Model.fromFile(dataFile);
      model.delete();
      expect(() => model.delete(), throwsA(isStateError));
    });

    test('missing file throws', () {
      if (File(missingFile).existsSync()) {
        fail('missingFile is not missing.');
      }
      expect(() => tfl.Model.fromFile(missingFile), throwsA(isArgumentError));
    });

    test('bad file throws', () {
      if (!File(badFile).existsSync()) {
        fail('badFile is missing.');
      }
      expect(() => tfl.Model.fromFile(badFile), throwsA(isArgumentError));
    });
  });

  test('interpreter from model', () {
    var model = tfl.Model.fromFile(dataFile);
    var interpreter = tfl.Interpreter(model);
    model.delete();
    interpreter.delete();
  });

  test('interpreter from file', () {
    var interpreter = tfl.Interpreter.fromFile(dataFile);
    interpreter.delete();
  });

  group('interpreter options', () {
    test('default', () {
      var options = tfl.InterpreterOptions();
      var interpreter = tfl.Interpreter.fromFile(dataFile, options: options);
      options.delete();
      interpreter.allocateTensors();
      interpreter.invoke();
      interpreter.delete();
    });

    test('threads', () {
      var options = tfl.InterpreterOptions()..threads = 1;
      var interpreter = tfl.Interpreter.fromFile(dataFile, options: options);
      options.delete();
      interpreter.allocateTensors();
      interpreter.invoke();
      interpreter.delete();
      // TODO(shanehop): Is there something meaningful to verify?
    });
  });

  group('interpreter', () {
    tfl.Interpreter interpreter;

    setUp(() => interpreter = tfl.Interpreter.fromFile(dataFile));
    tearDown(() => interpreter.delete());

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

    test('invoke succeeds if allocated', () {
      interpreter.allocateTensors();
      interpreter.invoke();
    });

    test('get input tensors', () {
      expect(interpreter.getInputTensors(), hasLength(1));
    });

    test('get output tensors', () {
      expect(interpreter.getOutputTensors(), hasLength(1));
    });

    test('get output tensors', () {
      expect(interpreter.getOutputTensors(), hasLength(1));
    });

    group('tensors', () {
      List<tfl.Tensor> tensors;
      setUp(() => tensors = interpreter.getInputTensors());

      test('name', () {
        expect(tensors[0].name, 'input');
      });

      test('type', () {
        expect(tensors[0].type, tfl.TFL_Type.uint8);
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
          expect(() => tensors[0].data = [0, 0, 0, 0], throwsA(isStateError));
        });

        test('set', () {
          interpreter.allocateTensors();
          tensors[0].data = [0, 0, 0, 0];
          expect(tensors[0].data, [0, 0, 0, 0]);
          tensors[0].data = [0, 1, 10, 100];
          expect(tensors[0].data, [0, 1, 10, 100]);
        });

        test('copyTo', () {
          interpreter.allocateTensors();
          expect(tensors[0].copyTo(), hasLength(4));
        });

        test('copyFrom throws if not allocated', () {
          expect(
              () => tensors[0].copyFrom([0, 0, 0, 0]), throwsA(isStateError));
        }, skip: 'segmentation fault!');
        // TODO(shanehop): Prevent data access for unallocated tensors.

        test('copyFrom', () {
          interpreter.allocateTensors();
          tensors[0].copyFrom([0, 0, 0, 0]);
          expect(tensors[0].data, [0, 0, 0, 0]);
          tensors[0].copyFrom([0, 1, 10, 100]);
          expect(tensors[0].data, [0, 1, 10, 100]);
        });
      });
    });
  });
}
