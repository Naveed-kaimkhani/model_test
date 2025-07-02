import 'dart:convert';
import 'package:flutter/services.dart';

class TFIDFVectorizer {
  late Map<String, int> vocabulary;
  late List<double> idf;

  Future<void> loadData() async {
    final String jsonString = await rootBundle.loadString('assets/tfidf_data.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    vocabulary = Map<String, int>.from(data['vocabulary']);
    idf = List<double>.from(data['idf']);
  }

  List<double> transform(String text) {
    final Map<String, int> termFreq = {};

    // Basic tokenizer: lowercase & split by space (you can improve this)
    final tokens = text.toLowerCase().split(RegExp(r'\s+'));

    // Count term frequency
    for (final token in tokens) {
      if (vocabulary.containsKey(token)) {
        termFreq[token] = (termFreq[token] ?? 0) + 1;
      }
    }

    // Build vector
    final vector = List<double>.filled(vocabulary.length, 0.0);
    for (final token in termFreq.keys) {
      final index = vocabulary[token]!;
      final tf = termFreq[token]! * 1.0;
      final idfValue = idf[index];
      vector[index] = tf * idfValue;
    }

    return vector;
  }
}
