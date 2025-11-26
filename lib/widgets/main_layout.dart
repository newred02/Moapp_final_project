import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/subjects_data.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

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

  double _getOverallProgress() {
    final totalProgress = subjectsData.fold<double>(
      0.0,
      (sum, subject) => sum + subject.progress,
    );
    return totalProgress / subjectsData.length;
  }

  @override
  Widget build(BuildContext context) {
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
                  // 앱 로고/아이콘
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
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 앱 제목
                  const Text(
                    'CS Interview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const Spacer(),

                  // 햄버거 메뉴 버튼
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
              // 드로어 헤더
              Container(
                height: 200,
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
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '면접 준비생',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '학습진도: ${(_getOverallProgress() * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _getOverallProgress(),
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 메뉴 항목들
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
                        // TODO: 설정 화면 구현
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('설정 화면은 준비 중입니다')),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.help,
                      title: '도움말',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: 도움말 화면 구현
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('도움말 화면은 준비 중입니다')),
                        );
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
                  ],
                ),
              ),

              // 하단 정보
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
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10,
                      ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: '학습',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: '면접',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF6B7280),
        size: 22,
      ),
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