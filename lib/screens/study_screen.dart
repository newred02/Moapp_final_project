import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/progress_ring.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subject.dart';
import '../services/database_service.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 과목 목록 가져오기
    return StreamBuilder<List<Subject>>(
      stream: DatabaseService().getSubjectsStream(),
      builder: (context, subjectSnapshot) {
        if (subjectSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (subjectSnapshot.hasError) {
          return Center(child: Text('오류: ${subjectSnapshot.error}'));
        }
        if (!subjectSnapshot.hasData || subjectSnapshot.data!.isEmpty) {
          return const Center(child: Text('등록된 과목이 없습니다.'));
        }

        final subjects = subjectSnapshot.data!;

        // 내 진도율 가져오기
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('study_progress')
              .snapshots(),
          builder: (context, progressSnapshot) {
            Map<String, double> progressMap = {};
            if (progressSnapshot.hasData) {
              for (var doc in progressSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                progressMap[doc.id] = (data['progress'] ?? 0.0).toDouble();
              }
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF8FAFC),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverallProgress(subjects, progressMap),
                    const SizedBox(height: 32),
                    const Text(
                      '과목별 학습',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSubjectCards(context, subjects, progressMap),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOverallProgress(List<Subject> subjects,
      Map<String, double> progressMap) {
    if (subjects.isEmpty) return const SizedBox.shrink();

    double totalProgress = subjects.fold(0.0, (sum, subject) {
      return sum + (progressMap[subject.id] ?? 0.0);
    });

    double averageProgress = totalProgress / subjects.length;
    int completedCount = subjects
        .where((s) => (progressMap[s.id] ?? 0.0) >= 1.0)
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '전체 학습 진도',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          ProgressRing(
            progress: averageProgress,
            size: 120,
            strokeWidth: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(averageProgress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${subjects.length}개 과목 중 $completedCount개 완료',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCards(BuildContext context,
      List<Subject> subjects,
      Map<String, double> progressMap) {
    return Column(
      children: subjects.map((subject) {
        final double myProgress = progressMap[subject.id] ?? 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSubjectCard(context, subject, myProgress),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject, double progress) {
    final Map<String, Color> subjectColors = {
      '알고리즘': const Color(0xFF3B82F6),
      '데이터베이스': const Color(0xFF10B981),
      '네트워크': const Color(0xFFEF4444),
      '운영체제': const Color(0xFFF59E0B),
    };

    final Color themeColor = subjectColors[subject.name] ?? const Color(0xFF3B82F6);
    final Color darkerThemeColor = Color.lerp(themeColor, Colors.black, 0.2)!;

    return GestureDetector(
      onTap: () => context.push('/study/${subject.id}', extra: subject),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    subject.icon,
                    color: themeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '진도율',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: LinearGradient(
                          colors: [
                            themeColor.withOpacity(0.6),
                            themeColor,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeColor,
                    darkerThemeColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      context.push('/study/${subject.id}', extra: subject),
                  borderRadius: BorderRadius.circular(12),
                  child: const Center(
                    child: Text(
                      '학습 계속하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}