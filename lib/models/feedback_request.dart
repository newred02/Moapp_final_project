import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackRequest {
  final String? uid;
  final String category;
  final int rating;
  final String environment;
  final String name;
  final String email;
  final String content;
  final bool isResolved;
  final dynamic createdAt;

  FeedbackRequest({
    this.uid,
    required this.category,
    required this.rating,
    required this.environment,
    required this.name,
    required this.email,
    required this.content,
    this.isResolved = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'category': category,
      'rating': rating,
      'environment': environment,
      'name': name,
      'email': email,
      'content': content,
      'isResolved': isResolved,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}