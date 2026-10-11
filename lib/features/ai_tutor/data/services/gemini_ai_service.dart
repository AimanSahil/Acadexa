import 'package:firebase_ai/firebase_ai.dart';

class GeminiAiService {
  GeminiAiService()
    : _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.8-flash');

  final GenerativeModel _model;
  Future<String> sendMessage(String message) async {
    final prompt = message.trim();

    if (prompt.isEmpty) {
      return 'Please enter a message.';
    }

    try {
      print('Gemini: sending request...');

      final response = await _model.generateContent([Content.text(prompt)]);

      print('Gemini: request completed.');
      print('Gemini response: ${response.text}');

      final answer = response.text?.trim();

      if (answer == null || answer.isEmpty) {
        throw Exception('Gemini returned an empty response.');
      }

      return answer;
    } catch (e, stackTrace) {
      print('Gemini error: $e');
      print(stackTrace);
      rethrow;
    }
  }
}
