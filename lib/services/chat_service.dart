// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/message_model.dart';
// import '../utils/constants.dart';
// import '../utils/helpers.dart';

// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   // Send a message
//   Future<void> sendMessage({
//     required String senderId,
//     required String receiverId,
//     required String content,
//   }) async {
//     try {
//       String chatId = AppHelpers.getChatId(senderId, receiverId);
//       String messageId = _firestore
//           .collection(AppConstants.chatsCollection)
//           .doc(chatId)
//           .collection(AppConstants.messagesCollection)
//           .doc()
//           .id;
      
//       MessageModel message = MessageModel(
//         messageId: messageId,
//         senderId: senderId,
//         receiverId: receiverId,
//         content: content,
//         timestamp: DateTime.now(),
//       );
      
//       // Add message to chat
//       await _firestore
//           .collection(AppConstants.chatsCollection)
//           .doc(chatId)
//           .collection(AppConstants.messagesCollection)
//           .doc(messageId)
//           .set(message.toMap());
      
//       // Update chat metadata (last message, timestamp)
//       await _firestore
//           .collection(AppConstants.chatsCollection)
//           .doc(chatId)
//           .set({
//         'participants': [senderId, receiverId],
//         'lastMessage': content,
//         'lastMessageTime': DateTime.now().toIso8601String(),
//         'lastSenderId': senderId,
//       }, SetOptions(merge: true));
      
//     } catch (e) {
//       throw Exception('Failed to send message: ${e.toString()}');
//     }
//   }
  
//   // Get messages stream for a chat
//   Stream<List<MessageModel>> getMessages({
//     required String userId,
//     required String otherUserId,
//   }) {
//     String chatId = AppHelpers.getChatId(userId, otherUserId);
    
//     return _firestore
//         .collection(AppConstants.chatsCollection)
//         .doc(chatId)
//         .collection(AppConstants.messagesCollection)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => MessageModel.fromMap(doc.data()))
//           .toList();
//     });
//   }
  
//   // Mark messages as read
//   Future<void> markAsRead({
//     required String userId,
//     required String otherUserId,
//   }) async {
//     try {
//       String chatId = AppHelpers.getChatId(userId, otherUserId);
      
//       QuerySnapshot unreadMessages = await _firestore
//           .collection(AppConstants.chatsCollection)
//           .doc(chatId)
//           .collection(AppConstants.messagesCollection)
//           .where('receiverId', isEqualTo: userId)
//           .where('isRead', isEqualTo: false)
//           .get();
      
//       for (var doc in unreadMessages.docs) {
//         await doc.reference.update({'isRead': true});
//       }
//     } catch (e) {
//       // Silently fail
//     }
//   }
// }

// lib/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Send a message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {
      String chatId = AppHelpers.getChatId(senderId, receiverId);
      String messageId = _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .doc()
          .id;
      
      MessageModel message = MessageModel(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
      );
      
      // Add message to chat
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .set(message.toMap());
      
      // Update chat metadata (last message, timestamp)
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .set({
        'chatId': chatId,
        'participants': [senderId, receiverId],
        'lastMessage': content,
        'lastMessageTime': DateTime.now().toIso8601String(),
        'lastMessageTimestamp': FieldValue.serverTimestamp(), // For ordering
        'lastSenderId': senderId,
      }, SetOptions(merge: true));
      
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
  
  // Get messages stream for a chat
  Stream<List<MessageModel>> getMessages({
    required String userId,
    required String otherUserId,
  }) {
    String chatId = AppHelpers.getChatId(userId, otherUserId);
    
    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }
  
  // Get all chats for a user - FIXED VERSION without composite index requirement
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatModel> chats = [];
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          final participants = List<String>.from(data['participants'] as List);
          final otherUserId = participants.firstWhere(
            (id) => id != userId,
            orElse: () => '',
          );
          
          if (otherUserId.isEmpty) continue;
          
          // Get other user's username
          String otherUsername = 'User';
          try {
            final userDoc = await _firestore
                .collection(AppConstants.usersCollection)
                .doc(otherUserId)
                .get();
            
            if (userDoc.exists && userDoc.data() != null) {
              otherUsername = userDoc.data()!['username'] as String? ?? 'User';
            }
          } catch (e) {
            print('Error getting username: $e');
          }
          
          // Count unread messages
          int unreadCount = 0;
          try {
            final unreadSnapshot = await _firestore
                .collection(AppConstants.chatsCollection)
                .doc(doc.id)
                .collection(AppConstants.messagesCollection)
                .where('receiverId', isEqualTo: userId)
                .where('isRead', isEqualTo: false)
                .get();
            
            unreadCount = unreadSnapshot.docs.length;
          } catch (e) {
            print('Error counting unread: $e');
          }
          
          chats.add(ChatModel(
            chatId: data['chatId'] as String? ?? doc.id,
            participants: participants,
            lastMessage: data['lastMessage'] as String? ?? '',
            lastMessageTime: data['lastMessageTime'] != null
                ? DateTime.parse(data['lastMessageTime'] as String)
                : DateTime.now(),
            lastSenderId: data['lastSenderId'] as String? ?? '',
            otherUserId: otherUserId,
            otherUsername: otherUsername,
            unreadCount: unreadCount,
          ));
        } catch (e) {
          print('Error processing chat: $e');
        }
      }
      
      // Sort by lastMessageTime in memory instead of in Firestore query
      chats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      
      return chats;
    });
  }
  
  // Mark messages as read
  Future<void> markAsRead({
    required String userId,
    required String otherUserId,
  }) async {
    try {
      String chatId = AppHelpers.getChatId(userId, otherUserId);
      
      QuerySnapshot unreadMessages = await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      // Silently fail
      print('Error marking as read: $e');
    }
  }
}