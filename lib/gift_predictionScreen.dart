import 'package:flutter/material.dart';
import 'gift_predictor.dart'; // Make sure this file contains your GiftPredictor class

class GiftPredictionScreen extends StatefulWidget {
  const GiftPredictionScreen({super.key});

  @override
  State<GiftPredictionScreen> createState() => _GiftPredictionScreenState();
}

class _GiftPredictionScreenState extends State<GiftPredictionScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController occasionController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController priceRangeController = TextEditingController();

  String prediction = '';
  bool loading = false;
  final GiftPredictor predictor = GiftPredictor();

  @override
  void initState() {
    super.initState();
    predictor.loadModel();
  }

  Future<void> predict() async {
    setState(() => loading = true);

    final combinedInput = "${ageController.text} | ${genderController.text} | "
        "${occasionController.text} | ${interestController.text} | ${priceRangeController.text}";

    final result = await predictor.predictGift(combinedInput);

    setState(() {
      prediction = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎁 Gift Recommendation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age Group (e.g. 18-25)')),
            TextField(controller: genderController, decoration: const InputDecoration(labelText: 'Gender (e.g. Male)')),
            TextField(controller: occasionController, decoration: const InputDecoration(labelText: 'Occasion (e.g. Birthday)')),
            TextField(controller: interestController, decoration: const InputDecoration(labelText: 'Interests (e.g. Tech)')),
            TextField(controller: priceRangeController, decoration: const InputDecoration(labelText: 'Price Range (e.g. 5000-10000)')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : predict,
              child: loading ? const CircularProgressIndicator() : const Text('Suggest Gift'),
            ),
            const SizedBox(height: 30),
            Text('🎁 Predicted Gift:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(prediction, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
