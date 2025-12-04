import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/subject.dart';
import '../services/progress_service.dart';

class StudyDetailScreen extends StatefulWidget {
  final Subject subject;

  const StudyDetailScreen({super.key, required this.subject});

  @override
  State<StudyDetailScreen> createState() => _StudyDetailScreenState();
}

class _StudyDetailScreenState extends State<StudyDetailScreen> {
  int currentSectionIndex = 0;
  int? selectedAnswer;
  bool showAnswer = false;

  Future<void> _saveProgress(String sectionId) async {
    try {
      await ProgressService().markSectionComplete(
        subjectId: widget.subject.id,
        sectionId: sectionId,
        totalSections: widget.subject.sections.length,
      );
    } catch (e) {
      print('진행률 저장 실패: $e');
    }
  }

  Widget build(BuildContext context) {
    final currentSection = widget.subject.sections[currentSectionIndex];
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('study_progress')
          .doc(widget.subject.id)
          .snapshots(),
      builder: (context, snapshot) {
        List<String> completedSections = [];
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data.containsKey('completedSections')) {
            completedSections = List<String>.from(data['completedSections']);
          }
        }

        final double realProgress = completedSections.length / widget.subject.sections.length;
        final bool isAlreadySolved = completedSections.contains(currentSection.id);

        return Scaffold(
          body: Container(
            color: const Color(0xFFF8FAFC),
            child: SafeArea(
              child: Column(
                children: [
                  _buildProgressHeader(realProgress, currentSectionIndex + 1, widget.subject.sections.length),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => context.pop(),
                              ),
                              Expanded(child: _buildSectionTitle(currentSection)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildContentSection(currentSection),
                          const SizedBox(height: 32),
                          _buildQuizSection(currentSection, isAlreadySolved),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomNavigation(isAlreadySolved),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressHeader(
    double progress,
    int currentStep,
    int totalSteps,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep / $totalSteps',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                ),
              ),
              Text(
                '${(progress * 100).round()}% 진행 중',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(StudySection section) {
    return Text(
      section.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildContentSection(StudySection section) {
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '학습 내용',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            section.content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(StudySection section, bool isAlreadySolved) {

    final bool isSolvedState = showAnswer || isAlreadySolved;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '퀴즈',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
              if (isAlreadySolved)
                const Text(
                  '✅ 학습 완료',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            section.quiz.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          ...section.quiz.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final bool isSelectedLocal = selectedAnswer == index;
            final isCorrect = index == section.quiz.correctAnswer;

            final bool displaySelected = isSolvedState
                ? isCorrect // 완료 상태면 정답에 체크 표시
                : isSelectedLocal; // 아니면 내가 누른 것 표시

            Color backgroundColor = Colors.white;
            Color borderColor = const Color(0xFFE5E7EB);
            Color textColor = const Color(0xFF374151);

            if (isSolvedState) {
              if (isCorrect) {
                backgroundColor = const Color(0xFF10B981).withOpacity(0.1);
                borderColor = const Color(0xFF10B981);
                textColor = const Color(0xFF10B981);
              } else if (isSelectedLocal && !isCorrect && !isAlreadySolved) {
                backgroundColor = const Color(0xFFEF4444).withOpacity(0.1);
                borderColor = const Color(0xFFEF4444);
                textColor = const Color(0xFFEF4444);
              }
            } else if (isSelectedLocal) {
              backgroundColor = const Color(0xFF3B82F6).withOpacity(0.1);
              borderColor = const Color(0xFF3B82F6);
              textColor = const Color(0xFF3B82F6);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: isSolvedState
                    ? null
                    : () {
                        setState(() {
                          selectedAnswer = index;
                        });
                      },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: borderColor, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: displaySelected
                              ? (isSolvedState
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF3B82F6))
                              : Colors.transparent,
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: displaySelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${index + 1}. $option',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),

          // 정답 확인 버튼
          if (!isSolvedState && selectedAnswer != null)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAnswer = true;
                  });

                  if (selectedAnswer == section.quiz.correctAnswer) {
                    // ★ 정답일 때만 저장 실행
                    _saveProgress(section.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('정답입니다! 🎉')),
                    );
                  } else {
                    // 오답일 때 피드백
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('오답입니다. 다시 시도해보세요!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '정답 확인',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

          if (isSolvedState) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 해설',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.quiz.explanation,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(bool isAlreadySolved) {
    final canGoPrevious = currentSectionIndex > 0;
    final canGoNext = currentSectionIndex < widget.subject.sections.length - 1;

    final bool canProceed = showAnswer || isAlreadySolved;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          if (canGoPrevious)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    currentSectionIndex--;
                    selectedAnswer = null;
                    showAnswer = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                ),
                child: const Text(
                  '이전 섹션',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ),
          if (canGoPrevious && canGoNext) const SizedBox(width: 16),
          if (canGoNext)
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                        setState(() {
                          currentSectionIndex++;
                          selectedAnswer = null;
                          showAnswer = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: showAnswer
                      ? const Color(0xFF3B82F6)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '다음 섹션',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (!canGoNext)
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '학습 완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
