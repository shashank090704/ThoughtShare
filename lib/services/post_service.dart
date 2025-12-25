// lib/services/post_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../utils/constants.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Create a new post
  Future<void> createPost({
    required String userId,
    required String username,
    required String content,
  }) async {
    try {
      String postId = _firestore.collection(AppConstants.postsCollection).doc().id;
      
      PostModel post = PostModel(
        postId: postId,
        userId: userId,
        username: username,
        content: content,
        createdAt: DateTime.now(),
      );
      
      await _firestore
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .set(post.toMap());
    } catch (e) {
      throw Exception('Failed to create post: ${e.toString()}');
    }
  }
  
  // Get all posts stream (real-time)
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection(AppConstants.postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }
  
  // Get posts by user ID
  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection(AppConstants.postsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }
  
  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete post: ${e.toString()}');
    }
  }
}