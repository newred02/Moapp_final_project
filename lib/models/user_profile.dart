import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String? photoURL;
  final bool isGuest;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    this.photoURL,
    this.isGuest = false,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    return UserProfile(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? 'Guest',
      photoURL: data['photoURL'],
      isGuest: data['isGuest'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'isGuest': isGuest,
    };
  }
}