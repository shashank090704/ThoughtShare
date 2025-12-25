//lib/models/post_model.dart
class PostModel {
  final String postId;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;
  
  PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
  });
  
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // Create from Firestore document
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      username: map['username'] as String? ?? '',
      content: map['content'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}