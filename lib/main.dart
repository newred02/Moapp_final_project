import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interview_project/screens/login_screen.dart';
import 'models/subject.dart';
import 'screens/home_screen.dart';
import 'screens/study_screen.dart';
import 'screens/study_detail_screen.dart';
import 'screens/interview_screen.dart';
import 'screens/interview_result_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_screen.dart';
import 'widgets/main_layout.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CSInterviewApp());
}

class CSInterviewApp extends StatelessWidget {
  CSInterviewApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isLoggingIn = state.uri.path == '/';
      // 로그인 상태인데 로그인 화면에 있다면 -> 홈으로 이동
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }
      // 로그인 안 했는데 홈이나 다른 곳에 가려 한다면 -> 로그인 화면으로
      if (!isLoggedIn && !isLoggingIn) {
        return '/';
      }

      return null; // 원래 가려던 곳으로 이동
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
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
        builder: (context, state) {
          final subject = state.extra as Subject;
          return StudyDetailScreen(subject: subject);
        },
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

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}