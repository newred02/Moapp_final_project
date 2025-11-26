import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/study_screen.dart';
import 'screens/study_detail_screen.dart';
import 'screens/interview_screen.dart';
import 'screens/interview_result_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_screen.dart';
import 'widgets/main_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        path: '/interview/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MainLayout(
            currentPath: state.uri.path,
            child: InterviewResultScreen(
              question: extra?['question'] ?? '',
              answer: extra?['answer'] ?? '',
              questionType: extra?['questionType'] ?? '기술면접',
            ),
          );
        },
      ),
      GoRoute(
        path: '/feedback',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const FeedbackScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => MainLayout(
          currentPath: state.uri.path,
          child: const HelpScreen(),
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