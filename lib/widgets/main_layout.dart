import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'gradient_text.dart';
import '../models/subject.dart';
import '../services/database_service.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({super.key, required this.child, required this.currentPath});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _getCurrentIndex() {
    if (widget.currentPath == '/') return 0;
    if (widget.currentPath.startsWith('/study')) return 1;
    if (widget.currentPath.startsWith('/interview')) return 2;
    return 0;
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그아웃 중 오류가 발생했습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GradientText(
                    'CS Interview',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cursive',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Color(0xFF1F2937),
                      size: 24,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Container(
          color: const Color(0xFFFAFAFA),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white24,
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user?.photoURL == null
                              ? const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.displayName ?? '면접 준비생',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        StreamBuilder<List<Subject>>(
                          stream: DatabaseService().getSubjectsStream(),
                          builder: (context, subjectSnapshot) {
                            if (!subjectSnapshot.hasData ||
                                subjectSnapshot.data!.isEmpty) {
                              return _buildProgressIndicator(0.0);
                            }

                            final subjects = subjectSnapshot.data!;

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .collection('study_progress')
                                  .snapshots(),
                              builder: (context, progressSnapshot) {
                                double overallProgress = 0.0;

                                if (progressSnapshot.hasData) {
                                  Map<String, double> progressMap = {};
                                  for (var doc in progressSnapshot.data!.docs) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    progressMap[doc.id] =
                                        (data['progress'] ?? 0.0).toDouble();
                                  }
                                  double totalSum = 0.0;
                                  for (var subject in subjects) {
                                    totalSum += progressMap[subject.id] ?? 0.0;
                                  }
                                  overallProgress = totalSum / subjects.length;
                                }

                                return _buildProgressIndicator(overallProgress);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.trending_up,
                      title: '학습진도',
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.quiz,
                      title: '면접연습',
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/interview');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: '설정',
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/settings');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.help,
                      title: '도움말',
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/help');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.feedback,
                      title: '피드백',
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/feedback');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: '로그아웃',
                      onTap: _handleLogout,
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  children: [
                    Divider(),
                    SizedBox(height: 8),
                    Text(
                      'CS Interview v1.0',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '© 2025 All rights reserved',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _getCurrentIndex(),
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/study');
                break;
              case 2:
                context.go('/interview');
                break;
            }
          },
          selectedItemColor: const Color(0xFF3B82F6),
          unselectedItemColor: const Color(0xFF9CA3AF),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: '학습'),
            BottomNavigationBarItem(icon: Icon(Icons.mic), label: '면접'),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '학습진도: ${(progress * 100).round()}%',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B7280), size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF374151),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 12,
    );
  }
}
