import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subject.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Subject>> getSubjectsStream() {
    return FirebaseFirestore.instance.collection('subjects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Subject.fromMap(doc.data())).toList();
    });
  }


  Future<List<InterviewQuestion>> getInterviewQuestions(String type) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('interview_questions')
          .where('type', isEqualTo: type)
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs
          .map((doc) => InterviewQuestion.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('질문 가져오기 에러: $e');
      return [];
    }
  }

  Future<void> markSectionComplete(String subjectId, String sectionId, int totalSections) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('study_progress')
        .doc(subjectId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      List<String> completedList = [];

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        completedList = List<String>.from(data['completedSections'] ?? []);
      }

      if (!completedList.contains(sectionId)) {
        completedList.add(sectionId);

        double newProgress = completedList.length / totalSections;

        if (newProgress > 1.0) newProgress = 1.0;

        transaction.set(docRef, {
          'progress': newProgress,
          'completedSections': completedList,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }

  Future<Map<String, dynamic>> getUserProgress(String subjectId) async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final doc = await _db
        .collection('users')
        .doc(user.uid)
        .collection('study_progress')
        .doc(subjectId)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return {};
  }
}