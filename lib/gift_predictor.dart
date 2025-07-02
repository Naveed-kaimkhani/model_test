import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:model_testing/TFIDFVectorizer.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class GiftPredictor {
  late Interpreter interpreter;
  late List<String> labels;
  final TFIDFVectorizer vectorizer = TFIDFVectorizer();

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/gift_model.tflite');
    final labelData = await rootBundle.loadString('assets/gift_labels.json');
    labels = List<String>.from(json.decode(labelData));
    await vectorizer.loadData(); // load TF-IDF
  }

  Future<String> predictGift(String combinedInput) async {
    final inputVector = vectorizer.transform(combinedInput);
    final input = [inputVector]; // Shape: [1, num_features]
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    interpreter.run(input, output);

    int predictedIndex = (output[0] as List<double>)
        .indexOf((output[0] as List<double>).reduce((a, b) => a > b ? a : b));

    return labels[predictedIndex];
  }
}
