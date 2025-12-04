import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_text.dart';
import '../services/database_service.dart';
import '../models/subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildLogo(),
                  const SizedBox(height: 24),
                  _buildWelcomeSection(),
                  const SizedBox(height: 32),
                  _buildMenuCards(context),
                  const SizedBox(height: 24),
                  _buildStudyProgress(),
                  const SizedBox(height: 24),
                  _buildBottomNavigation(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(
            Icons.school,
            color: Colors.white,
            size: 45,
          ),
        ),
        const SizedBox(height: 16),
        GradientText(
          'CS Interview',
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
            fontFamily: 'Cursive',
            fontStyle: FontStyle.italic,
          ),
        ),
        const Text(
          '컴퓨터공학과 면접 준비',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            '안녕하세요! 👋',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '오늘도 열심히 공부해서\n꿈의 회사에 합격해봐요!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCards(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                context,
                '전공지식 학습',
                '체계적인 CS 이론 학습',
                Icons.book,
                const Color(0xFF3B82F6),
                () => context.push('/study'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMenuCard(
                context,
                '면접 연습',
                '실전 면접 시뮬레이션',
                Icons.mic,
                const Color(0xFF10B981),
                () => context.push('/interview'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                context,
                '피드백 제출',
                '앱 개선 의견 전달',
                Icons.feedback,
                const Color(0xFFEF4444),
                () => context.push('/feedback'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMenuCard(
                context,
                '학습 통계',
                '내 진도율 확인',
                Icons.analytics,
                const Color(0xFFF59E0B),
                () => {}, // TODO: 통계 페이지
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyProgress() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<List<Subject>>(
      stream: DatabaseService().getSubjectsStream(),
      builder: (context, subjectSnapshot) {
        if (subjectSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (subjectSnapshot.hasError || !subjectSnapshot.hasData || subjectSnapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final originalSubjects = subjectSnapshot.data!;

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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '학습 진도 현황',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: originalSubjects.map((subject) {
                        final realProgress = progressMap[subject.id] ?? 0.0;
                        final percent = (realProgress * 100).round();

                        final colors = [
                          const Color(0xFF3B82F6),
                          const Color(0xFF10B981),
                          const Color(0xFFEF4444),
                          const Color(0xFFF59E0B),
                        ];

                        final index = originalSubjects.indexOf(subject);
                        final color = colors[index % colors.length];

                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildProgressItem(
                            subject.name,
                            percent,
                            color,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressItem(String subject, int progress, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(color),
                    backgroundColor: color.withOpacity(0.2),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '$progress%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subject,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            text: '학습 시작하기',
            onPressed: () => context.push('/study'),
            colors: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GradientButton(
            text: '면접 연습하기',
            onPressed: () => context.push('/interview'),
            colors: const [Color(0xFF10B981), Color(0xFF059669)],
          ),
        ),
      ],
    );
  }
}