import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/study_screen.dart';
import 'screens/study_detail_screen.dart';
import 'screens/interview_screen.dart';
import 'screens/feedback_screen.dart';
import 'widgets/main_layout.dart';

void main() {
  runApp(CSInterviewApp());
}

class CSInterviewApp extends StatelessWidget {
  CSInterviewApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/study',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const StudyScreen(),
        ),
      ),
      GoRoute(
        path: '/study/:id',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: StudyDetailScreen(
            id: state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: '/interview',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const InterviewScreen(),
        ),
      ),
      GoRoute(
        path: '/feedback',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const FeedbackScreen(),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CS Interview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansKR',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF8B5CF6),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F2937),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}