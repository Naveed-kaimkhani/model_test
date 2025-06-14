import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class GiftPredictor {
  late Interpreter interpreter;
  late List<String> labels;

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/gift_model.tflite');
    final labelData = await rootBundle.loadString('assets/gift_labels.json');
    labels = List<String>.from(json.decode(labelData));
  }

  Future<String> predictGift(String combinedInput) async {
    // NOTE: You need to vectorize combinedInput to the same format as used in Python (TF-IDF)
    // For now, assume it's already vectorized and passed as List<double> (mocked)

    final List<double> inputVector =
        List.filled(100, 0.0); // Replace with real input
    var input = [inputVector]; // Shape: [1, num_features]

    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    interpreter.run(input, output);

int predictedIndex = (output[0] as List<double>)
    .indexOf((output[0] as List<double>).reduce((a, b) => a > b ? a : b));

    return labels[predictedIndex];
  }
}
