import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/gradient_button.dart';
import '../data/subjects_data.dart';
import '../models/subject.dart';
import 'dart:math';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with TickerProviderStateMixin {
  String selectedType = '기술면접';
  InterviewQuestion? currentQuestion;
  bool isRecording = false;
  late AnimationController _recordingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _recordingController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _recordingController, curve: Curves.easeInOut),
    );
    _recordingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _recordingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (isRecording) _recordingController.forward();
      }
    });
    _loadRandomQuestion();
  }

  @override
  void dispose() {
    _recordingController.dispose();
    super.dispose();
  }

  void _loadRandomQuestion() {
    final questions = selectedType == '기술면접'
        ? technicalQuestions
        : personalityQuestions;
    final random = Random();
    setState(() {
      currentQuestion = questions[random.nextInt(questions.length)];
    });
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });

    if (isRecording) {
      _recordingController.forward();
    } else {
      _recordingController.stop();
      _recordingController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const AppBarWidget(
        title: '면접 연습',
        showBackButton: true,
        actions: [
          Icon(Icons.settings, color: Color(0xFF6B7280)),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeatureBanner(),
            const SizedBox(height: 32),
            _buildInterviewTypeSelector(),
            const SizedBox(height: 32),
            if (currentQuestion != null) ...[
              _buildQuestionCard(),
              const SizedBox(height: 32),
              _buildRecordingSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'STT/TTS 기능',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '음성 인식으로 자동 답변 기록\n음성 합성으로 질문 읽어주기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '면접 유형 선택',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                '기술면접',
                'CS 전공지식 질문',
                Icons.code,
                const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTypeCard(
                '인성면접',
                '인성 및 경험 질문',
                Icons.person,
                const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard(String type, String description, IconData icon, Color color) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
        _loadRandomQuestion();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selectedType == '기술면접'
                      ? const Color(0xFF3B82F6).withOpacity(0.1)
                      : const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentQuestion!.type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selectedType == '기술면접'
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF10B981),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentQuestion!.difficulty,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            currentQuestion!.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: TTS 기능 구현
                },
                icon: const Icon(Icons.volume_up),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                  foregroundColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '질문 듣기',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Column(
      children: [
        const Text(
          '답변을 녹음해주세요',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedBuilder(
              animation: _recordingController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isRecording
                              ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                              : [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isRecording
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF3B82F6)).withOpacity(0.3),
                            offset: const Offset(0, 8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isRecording ? '녹음 중... 탭하여 중지' : '탭하여 녹음 시작',
          style: TextStyle(
            fontSize: 14,
            color: isRecording ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GradientButton(
          text: '새로운 질문',
          onPressed: _loadRandomQuestion,
          width: double.infinity,
          colors: const [Color(0xFF10B981), Color(0xFF059669)],
        ),
        const SizedBox(height: 16),
        GradientButton(
          text: '녹음 완료 & 피드백 받기',
          onPressed: () => context.push('/feedback'),
          width: double.infinity,
          colors: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
      ],
    );
  }
}