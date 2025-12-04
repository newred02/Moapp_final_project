import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> markSectionComplete({
    required String subjectId,
    required String sectionId,
    required int totalSections,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('study_progress')
        .doc(subjectId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      List<String> completedList = [];

      if (snapshot.exists && snapshot.data()!.containsKey('completedSections')) {
        completedList = List<String>.from(snapshot.data()!['completedSections']);
      }

      if (completedList.contains(sectionId)) {
        return;
      }

      completedList.add(sectionId);

      double newProgress = completedList.length / totalSections;
      if (newProgress > 1.0) newProgress = 1.0;

      transaction.set(docRef, {
        'subjectId': subjectId,
        'completedSections': completedList,
        'progress': newProgress,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }
}