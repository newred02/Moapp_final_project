import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreSettingsService {
  static final FirestoreSettingsService _instance = FirestoreSettingsService._internal();
  factory FirestoreSettingsService() => _instance;
  FirestoreSettingsService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference get _settingsRef {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다.');
    }
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('config')
        .doc('settings');
  }

  // 설정값 불러오기
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return _getDefaultSettings();

      final snapshot = await _settingsRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('설정 불러오기 실패: $e');
    }

    return _getDefaultSettings();
  }

  // 설정값 개별 업데이트
  Future<void> updateSetting(String key, dynamic value) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _settingsRef.set(
        {key: value},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('설정 저장 실패: $e');
    }
  }

  // 기본값 정의
  Map<String, dynamic> _getDefaultSettings() {
    return {
      'speechSpeed': 0.6,
      'voiceFeedback': true,
      'autoSaveProgress': true,
      'dailyGoal': 30,
      'studyReminder': true,
      'pushNotification': true,
      'soundEffect': true,
    };
  }
}