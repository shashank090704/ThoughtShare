// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String email;
  final String username;
  final DateTime createdAt;
  
  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
  });
  
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      username: map['username'] as String? ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}