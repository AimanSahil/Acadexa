
import 'package:dio/dio.dart';

class GeminiAiService {
  GeminiAiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 90),
          ),
        );

  final Dio _dio;

  Future<String> sendMessage(String message) async {
    final prompt = message.trim();

    if (prompt.isEmpty) {
      return 'Please enter a message.';
    }

    const apiKey = String.fromEnvironment('GEMINI_API_KEY');

    if (apiKey.isEmpty) {
      throw Exception(
        'Gemini API key is missing. Run Flutter with '
        '--dart-define=GEMINI_API_KEY=YOUR_API_KEY',
      );
    }

    const maxAttempts = 3;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await _dio.post(
          '/models/gemini-3.8-flash:generateContent',
          queryParameters: {'key': apiKey},
          data: {
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                ],
              },
            ],
            'generationConfig': {
             'maxOutputTokens': 64,
            },
          },
        );

        final candidates = response.data['candidates'] as List?;
        final content = candidates != null && candidates.isNotEmpty
            ? candidates.first['content']
            : null;
        final parts = content?['parts'] as List?;

        final answer = parts
            ?.where((part) => part['text'] != null)
            .map((part) => part['text'] as String)
            .join('\n')
            .trim();

        if (answer == null || answer.isEmpty) {
          throw Exception('Gemini returned an empty response.');
        }

        return answer;
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;

        final shouldRetry = statusCode == 429 ||
            statusCode == 500 ||
            statusCode == 502 ||
            statusCode == 503 ||
            statusCode == 504 ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError;

        if (!shouldRetry || attempt == maxAttempts) {
          final details = e.response?.data ?? e.message;

          throw Exception(
            'Gemini API request failed '
            '(HTTP ${statusCode ?? 'network error'}). '
            'Details: $details',
          );
        }

        await Future<void>.delayed(
          Duration(seconds: attempt * 3),
        );
      }
    }

    throw Exception('Gemini could not complete the request.');
  }
}
