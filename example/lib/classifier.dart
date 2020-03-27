import 'package:flutter/services.dart';
import 'package:tflite_flutter_plugin/tflite.dart';

class Classifier {
  final _MODEL_FILE = 'text_classification.tflite';
  final _VOCAB_FILE = 'text_classification_vocab.txt';

  final int _SENTENCE_LEN = 256;

  final String START = '<START>';
  final String PAD = '<PAD>';
  final String UNKNOWN = '<UNKNOWN>';

  Map<String, int> _dict;

  Interpreter _interpreter;

  Classifier() {
    _loadModel();
    _loadDictionary();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset(_MODEL_FILE);
    print('Interpreter loaded successfully');
  }

  void _loadDictionary() async {
    final vocab = await rootBundle.loadString('assets/$_VOCAB_FILE');
    var dict = <String, int>{};
    final vocabList = vocab.split('\n');
    for (var i = 0; i < vocabList.length; i++) {
      var entry = vocabList[i].trim().split(' ');
      dict[entry[0]] = int.parse(entry[1]);
    }
    _dict = dict;
    print('Dictionary loaded successfully');
  }

  int classify(String rawText) {
    var input = tokenizeInputText(rawText);
    var output = List<double>(2).reshape([1, 2]);
    _interpreter.run(input, output);

    var s = 0;
    if ((output[0][0] as double) > (output[0][1] as double)) {
      s = 0;
    } else {
      s = 1;
    }
    return s;
  }

  List<List<double>> tokenizeInputText(String text) {
    final toks = text.split(' ');
    var vec = List<double>.filled(_SENTENCE_LEN, _dict[PAD].toDouble());

    var index = 0;
    if (_dict.containsKey(START)) {
      vec[index++] = _dict[START].toDouble();
    }

    for (var tok in toks) {
      if (index > _SENTENCE_LEN) {
        break;
      }
      vec[index++] = _dict.containsKey(tok)
          ? _dict[tok].toDouble()
          : _dict[UNKNOWN].toDouble();
    }

    return [vec];
  }
}
