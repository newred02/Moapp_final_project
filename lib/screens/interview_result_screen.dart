import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/gpt_service.dart';
import '../widgets/gradient_button.dart';

class InterviewResultScreen extends StatefulWidget {
  final String question;
  final String answer;
  final String questionType;

  const InterviewResultScreen({
    super.key,
    required this.question,
    required this.answer,
    required this.questionType,
  });

  @override
  State<InterviewResultScreen> createState() => _InterviewResultScreenState();
}

class _InterviewResultScreenState extends State<InterviewResultScreen>
    with SingleTickerProviderStateMixin {
  InterviewFeedback? _feedback;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _evaluateAnswer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _evaluateAnswer() async {
    try {
      final feedback = await GptService.evaluateAnswer(
        question: widget.question,
        answer: widget.answer,
        questionType: widget.questionType,
      );
      setState(() {
        _feedback = feedback;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEBF4FF),
            Colors.white,
            Color(0xFFF5F3FF),
          ],
        ),
      ),
      child: _isLoading ? _buildLoadingView() : _buildResultView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3B82F6),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'AI가 답변을 분석하고 있습니다...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '잠시만 기다려주세요',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    if (_feedback == null) {
      return const Center(
        child: Text('평가 결과를 불러올 수 없습니다.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreCard(),
          const SizedBox(height: 24),
          _buildSummaryCard(),
          const SizedBox(height: 24),
          _buildQuestionAnswerCard(),
          const SizedBox(height: 24),
          _buildStrengthsCard(),
          const SizedBox(height: 24),
          _buildImprovementsCard(),
          const SizedBox(height: 24),
          _buildModelAnswerCard(),
          const SizedBox(height: 32),
          _buildActionButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getScoreGradient(_feedback!.score),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getScoreGradient(_feedback!.score)[0].withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '종합 점수',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return Text(
                '${(_feedback!.score * _scoreAnimation.value).round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const Text(
            '/ 100',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getScoreLabel(_feedback!.score),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Color(0xFF3B82F6),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _feedback!.summary,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1E40AF),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnswerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.questionType,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '질문',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            '내 답변',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.answer,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.thumb_up,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '잘한 점',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_feedback!.strengths.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _feedback!.strengths[index],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF374151),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildImprovementsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '개선할 점',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_feedback!.improvements.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _feedback!.improvements[index],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF374151),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModelAnswerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '모범 답안',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              _feedback!.modelAnswer,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GradientButton(
          text: '다른 질문 연습하기',
          onPressed: () => context.go('/interview'),
          width: double.infinity,
          colors: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => context.go('/'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF3B82F6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '홈으로 돌아가기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B82F6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getScoreGradient(int score) {
    if (score >= 90) {
      return [const Color(0xFF10B981), const Color(0xFF059669)];
    } else if (score >= 70) {
      return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
    } else if (score >= 50) {
      return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
    } else {
      return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
    }
  }

  String _getScoreLabel(int score) {
    if (score >= 90) {
      return '훌륭합니다! 🎉';
    } else if (score >= 70) {
      return '좋습니다! 👍';
    } else if (score >= 50) {
      return '보완이 필요해요 💪';
    } else {
      return '더 연습해보세요 📚';
    }
  }
}
