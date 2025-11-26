import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GptService {
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// 면접 답변 평가
  static Future<InterviewFeedback> evaluateAnswer({
    required String question,
    required String answer,
    required String questionType, // 기술면접 or 인성면접
  }) async {
    final prompt = '''
당신은 IT 기업의 면접관입니다. 지원자의 답변을 평가해주세요.

[면접 유형]: $questionType
[질문]: $question
[지원자 답변]: $answer

다음 형식으로 평가해주세요:

1. 종합 점수 (0-100점)
2. 강점 (2-3가지)
3. 개선점 (2-3가지)
4. 모범 답안 예시
5. 한줄 총평

반드시 아래 JSON 형식으로만 응답해주세요:
{
  "score": 85,
  "strengths": ["강점1", "강점2"],
  "improvements": ["개선점1", "개선점2"],
  "modelAnswer": "모범 답안 내용",
  "summary": "한줄 총평 내용"
}
''';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': '당신은 IT 기업의 전문 면접관입니다. 지원자의 답변을 친절하고 건설적으로 평가합니다. 반드시 JSON 형식으로만 응답합니다.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;

        // JSON 파싱
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
        if (jsonMatch != null) {
          final feedbackJson = jsonDecode(jsonMatch.group(0)!);
          return InterviewFeedback(
            score: feedbackJson['score'] ?? 0,
            strengths: List<String>.from(feedbackJson['strengths'] ?? []),
            improvements: List<String>.from(feedbackJson['improvements'] ?? []),
            modelAnswer: feedbackJson['modelAnswer'] ?? '',
            summary: feedbackJson['summary'] ?? '',
          );
        }
      }

      throw Exception('API 응답 파싱 실패');
    } catch (e) {
      // 에러 시 기본 피드백 반환
      return InterviewFeedback(
        score: 70,
        strengths: ['답변을 완료했습니다', '면접에 참여했습니다'],
        improvements: ['더 구체적인 예시를 들어보세요', '핵심 키워드를 포함해보세요'],
        modelAnswer: '네트워크 연결을 확인하고 다시 시도해주세요.',
        summary: '평가 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }
}

class InterviewFeedback {
  final int score;
  final List<String> strengths;
  final List<String> improvements;
  final String modelAnswer;
  final String summary;

  InterviewFeedback({
    required this.score,
    required this.strengths,
    required this.improvements,
    required this.modelAnswer,
    required this.summary,
  });
}
