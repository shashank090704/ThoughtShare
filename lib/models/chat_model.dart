// lib/models/chat_model.dart
class ChatModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastSenderId;
  final String otherUserId;
  final String otherUsername;
  final int unreadCount;
  
  ChatModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastSenderId,
    required this.otherUserId,
    required this.otherUsername,
    this.unreadCount = 0,
  });
  
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastSenderId': lastSenderId,
    };
  }
  
  // Create from Firestore document
  factory ChatModel.fromMap(Map<String, dynamic> map, String currentUserId) {
    final participants = List<String>.from(map['participants'] as List);
    final otherUserId = participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    
    return ChatModel(
      chatId: map['chatId'] as String? ?? '',
      participants: participants,
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.parse(map['lastMessageTime'] as String)
          : DateTime.now(),
      lastSenderId: map['lastSenderId'] as String? ?? '',
      otherUserId: otherUserId,
      otherUsername: map['otherUsername'] as String? ?? 'User',
      unreadCount: map['unreadCount'] as int? ?? 0,
    );
  }
}